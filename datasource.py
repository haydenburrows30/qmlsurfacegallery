# Copyright (C) 2023 The Qt Company Ltd.
# SPDX-License-Identifier: LicenseRef-Qt-Commercial OR BSD-3-Clause
from __future__ import annotations

import numpy as np
from math import sin, pi
import os

from PySide6.QtCore import (QObject, QRunnable, QThreadPool, QMutex, QMutexLocker,
                           QRandomGenerator, Slot, Signal, QElapsedTimer)
from PySide6.QtQml import QmlElement
from PySide6.QtGui import QVector3D
from PySide6.QtDataVisualization import QSurfaceDataItem, QSurface3DSeries

# Attempt to import pyopencl for GPU acceleration if available
try:
    import pyopencl as cl
    HAS_OPENCL = True
except ImportError:
    HAS_OPENCL = False

QML_IMPORT_NAME = "SurfaceGallery"
QML_IMPORT_MAJOR_VERSION = 1

# Global data cache to avoid recreating the same data
DATA_CACHE = {}

class DataGeneratorWorker(QRunnable):
    """Worker class for generating data in separate thread"""
    
    class Signals(QObject):
        finished = Signal(list, int)
        
    def __init__(self, row_start, row_count, column_count,
                 x_min, x_max, y_min, y_max, z_min, z_max, cache_index):
        super().__init__()
        self.row_start = row_start
        self.row_count = row_count
        self.column_count = column_count
        self.x_min = x_min
        self.x_max = x_max
        self.y_min = y_min
        self.y_max = y_max
        self.z_min = z_min
        self.z_max = z_max
        self.cache_index = cache_index
        self.signals = self.Signals()
        
    def run(self):
        # Create a cache key for this calculation
        cache_key = f"{self.row_start}_{self.row_count}_{self.column_count}_{self.x_min}_{self.x_max}_{self.y_min}_{self.y_max}_{self.z_min}_{self.z_max}_{self.cache_index}"
        
        # Check if we have this data cached
        if cache_key in DATA_CACHE:
            self.signals.finished.emit(DATA_CACHE[cache_key], self.cache_index)
            return
            
        # Use NumPy for faster computation when possible
        try:
            # Generate data using NumPy vectorization
            cache = self._generate_numpy()
        except Exception:
            # Fall back to standard computation
            cache = self._generate_standard()
            
        # Cache the result for future use
        DATA_CACHE[cache_key] = cache
        
        # Emit result
        self.signals.finished.emit(cache, self.cache_index)
    
    def _generate_numpy(self):
        """Generate data using NumPy for faster computation"""
        x_range = self.x_max - self.x_min
        y_range = self.y_max - self.y_min
        z_range = self.z_max - self.z_min
        
        # Create coordinate arrays
        row_indices = np.linspace(self.row_start, self.row_start + self.row_count - 1, self.row_count)
        col_indices = np.linspace(0, self.column_count - 1, self.column_count)
        
        # Create grid of coordinates
        row_mod = row_indices / (self.row_count + self.row_start)
        y_range_mod = y_range * row_mod[:, np.newaxis]
        z_range_mod = z_range * row_mod[:, np.newaxis]
        z = z_range_mod + self.z_min
        row_col_wave_angle_mul = pi * pi * row_mod[:, np.newaxis]
        row_col_wave_mul = y_range_mod * 0.2
        
        # Create column modifiers
        col_mod = col_indices / self.column_count
        x_range_mod = x_range * col_mod
        x = x_range_mod + self.x_min
        
        # Generate sine waves
        col_wave = np.sin((2.0 * pi * col_mod) - (1.0 / 2.0 * pi)) + 1.0
        
        # Generate random values once
        rand_gen = QRandomGenerator.global_()
        rand_values = np.array([rand_gen.generateDouble() for _ in range(self.row_count * self.column_count)])
        rand_values = rand_values.reshape(self.row_count, self.column_count) * 0.15
        
        # Calculate y values
        y_values = (col_wave * row_col_wave_mul) + (self.y_min + y_range_mod) + (rand_values * y_range)
        
        # Convert to QSurfaceDataItem list of lists
        cache = []
        for i in range(self.row_count):
            row = []
            for j in range(self.column_count):
                item = QSurfaceDataItem(QVector3D(x[j], y_values[i, j], z[i, 0]))
                row.append(item)
            cache.append(row)
        
        return cache
        
    def _generate_standard(self):
        """Generate data using standard computation (fallback)"""
        x_range = self.x_max - self.x_min
        y_range = self.y_max - self.y_min
        z_range = self.z_max - self.z_min
        
        cache = []
        rand_gen = QRandomGenerator.global_()
        
        for j in range(self.row_start, self.row_start + self.row_count):
            row = []
            rowMod = (float(j)) / float(self.row_count + self.row_start)
            yRangeMod = y_range * rowMod
            zRangeMod = z_range * rowMod
            z = zRangeMod + self.z_min
            rowColWaveAngleMul = pi * pi * rowMod
            rowColWaveMul = yRangeMod * 0.2
            
            for k in range(0, self.column_count):
                colMod = (float(k)) / float(self.column_count)
                xRangeMod = x_range * colMod
                x = xRangeMod + self.x_min
                colWave = sin((2.0 * pi * colMod) - (1.0 / 2.0 * pi)) + 1.0
                rand_nr = rand_gen.generateDouble() * 0.15
                y = (colWave * rowColWaveMul) + (self.y_min + yRangeMod) + (rand_nr * y_range)
                
                item = QSurfaceDataItem(QVector3D(x, y, z))
                row.append(item)
            
            cache.append(row)
            
        return cache


@QmlElement
class DataSource(QObject):

    fileError = Signal(str)
    fileAccepted = Signal(str)
    dataReady = Signal()
    dataProgress = Signal(int)

    def __init__(self, parent=None):
        super().__init__(parent)
        self.m_index = -1
        self.m_resetArray = None
        self.m_data = []
        self.m_thread_pool = QThreadPool.globalInstance()
        self.m_mutex = QMutex()
        self.m_partial_results = {}
        self.m_timer = QElapsedTimer()
        self.m_lod_enabled = True
        self.max_file_size = 100 * 1024 * 1024  # 100MB in bytes
        
        # Configure the thread pool (adjust based on your system)
        optimal_threads = max(4, QThreadPool.globalInstance().maxThreadCount() - 1)
        self.m_thread_pool.setMaxThreadCount(optimal_threads)

    @Slot(str)
    def checkAndProcessFile(self, file_url):
        """Check file size and process if valid"""
        try:
            # Convert QUrl to file path
            if file_url.startswith('file:///'):
                file_path = file_url[7:]
            elif file_url.startswith('file://'):
                file_path = file_url[5:]
            else:
                file_path = file_url

            # Skip size check for resource files
            if file_path.startswith(':/'):
                self.fileAccepted.emit(file_path)
                return

            # Check if file exists
            if not os.path.exists(file_path):
                self.fileError.emit(f"File not found: {file_path}")
                return

            # Check file size
            file_size = os.path.getsize(file_path)
            if file_size > self.max_file_size:
                self.fileError.emit(f"File too large (max size is 10MB)")
                return

            # File is valid
            self.fileAccepted.emit(file_path)

        except Exception as e:
            self.fileError.emit(f"Error processing file: {str(e)}")

    @Slot(int, int, int, float, float, float, float, float, float)
    def generateData(self, cacheCount, rowCount, columnCount,
                     xMin, xMax, yMin, yMax, zMin, zMax):
        if not cacheCount or not rowCount or not columnCount:
            return

        self.clearData()
        self.m_timer.start()
        
        # Create a cache key for the entire dataset
        cache_key = f"{cacheCount}_{rowCount}_{columnCount}_{xMin}_{xMax}_{yMin}_{yMax}_{zMin}_{zMax}"
        
        # Check if we have the entire dataset cached
        if cache_key in DATA_CACHE:
            with QMutexLocker(self.m_mutex):
                self.m_data = DATA_CACHE[cache_key]
                print("Using cached dataset")
                self.dataProgress.emit(100)
                self.dataReady.emit()
                return
        
        # Apply level of detail if needed
        if self.m_lod_enabled and (rowCount > 100 or columnCount > 100):
            target_row_count = min(rowCount, 100)
            target_col_count = min(columnCount, 100)
            
            # Only apply LOD if we're significantly reducing the data
            if target_row_count * target_col_count < rowCount * columnCount * 0.7:
                print(f"Applying Level of Detail: {rowCount}x{columnCount} -> {target_row_count}x{target_col_count}")
                rowCount = target_row_count
                columnCount = target_col_count
        
        # Set up empty data array to be filled by workers
        with QMutexLocker(self.m_mutex):
            self.m_data = [None] * cacheCount
            self.m_partial_results = {}
        
        # Calculate work distribution - each thread gets a chunk of rows
        threads_to_use = min(self.m_thread_pool.maxThreadCount(), cacheCount)
        cache_per_thread = max(1, cacheCount // threads_to_use)
        
        for i in range(0, cacheCount, cache_per_thread):
            end_index = min(i + cache_per_thread, cacheCount)
            for cache_index in range(i, end_index):
                worker = DataGeneratorWorker(0, rowCount, columnCount, 
                                            xMin, xMax, yMin, yMax, zMin, zMax, cache_index)
                worker.signals.finished.connect(self.handleWorkerResult)
                self.m_thread_pool.start(worker)

    def handleWorkerResult(self, cache_data, cache_index):
        with QMutexLocker(self.m_mutex):
            self.m_data[cache_index] = cache_data
            progress = int((cache_index + 1) * 100 / len(self.m_data))
            self.dataProgress.emit(progress)
            
            all_ready = all(x is not None for x in self.m_data)
            
            if all_ready:
                # Cache the result for future use
                cache_key = f"{len(self.m_data)}_{len(self.m_data[0])}_{len(self.m_data[0][0])}"
                DATA_CACHE[cache_key] = self.m_data

                self.dataReady.emit()

    @Slot(QSurface3DSeries)
    def update(self, series):
        if series and self.m_data:
            with QMutexLocker(self.m_mutex):
                # Each iteration uses data from a different cached array
                self.m_index += 1
                if self.m_index > len(self.m_data) - 1:
                    self.m_index = 0

                array = self.m_data[self.m_index]
                if not array:
                    return  # Skip if data not ready
                    
                newRowCount = len(array)
                newColumnCount = len(array[0]) if newRowCount > 0 else 0

                # Copy items from our cache to the reset array
                self.m_resetArray = []
                for i in range(0, newRowCount):
                    sourceRow = array[i]
                    row = []
                    for j in range(0, newColumnCount):
                        row.append(sourceRow[j])
                    self.m_resetArray.append(row)

                # Notify the proxy that data has changed
                series.dataProxy().resetArray(self.m_resetArray)

    @Slot()
    def clearData(self):
        with QMutexLocker(self.m_mutex):
            self.m_data = []
            self.m_partial_results = {}
            self.m_index = -1
            
    @Slot(bool)
    def setLodEnabled(self, enabled):
        self.m_lod_enabled = enabled
        
    @Slot()
    def clearCache(self):
        global DATA_CACHE
        DATA_CACHE = {}
        print("Data cache cleared")
