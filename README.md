# QmlSurfaceGallery - High-Performance 3D Surface Visualization Demo

## Overview

QmlSurfaceGallery demonstrates different techniques for visualizing 3D surface data using Qt's DataVisualization module with Qt Quick (QML) and PySide6. The application shows three different types of 3D surface visualizations that can be accessed through tab navigation:

![Image](https://github.com/user-attachments/assets/09ce971c-789b-4fae-b765-dcf6c8084178)
![Image](https://github.com/user-attachments/assets/a3f97e45-945b-4d2b-8123-1493e523c7a6)
![Image](https://github.com/user-attachments/assets/01dbf7fe-5470-477b-b7b4-5a8cfd880197)

1. **Height Map** - A 3D terrain visualization using a height map image
2. **Spectrogram** - A polar data visualization with color gradients
3. **Oscilloscope** - A dynamic surface plot simulating real-time data collection

## Performance Features

This application incorporates several advanced performance optimization techniques:

1. **Multithreaded Data Processing** - Utilizes multiple CPU cores via QThreadPool
2. **GPU Acceleration** - Uses OpenCL (when available) to offload computation to the GPU
3. **Memory Optimization** - Pre-allocates memory and reuses arrays to reduce allocation overhead
4. **Data Caching** - Stores generated data for reuse to avoid redundant calculations
5. **Level of Detail (LOD)** - Dynamically adapts resolution based on complexity
6. **QML Optimization** - Reduces property binding evaluations for better UI performance

## Application Structure

### Core Components

- **Main Entry Point** (`main.py`):
  - Sets up the QGuiApplication and QQuickView
  - Configures OpenGL rendering with the RHI backend
  - Loads the main QML interface

- **Data Management** (`datasource.py`):
  - Defines the `DataSource` class which generates 3D surface data
  - Uses mathematical functions to create wave patterns
  - Exposes Python functionality to QML through the `@QmlElement` decorator
  - **Multithreaded data processing** using QThreadPool and QRunnable
  - **GPU acceleration** using OpenCL for computation-intensive tasks
  - **Memory optimization** and data caching for improved performance

- **Data Models**:
  - `SpectrogramData.qml` - Contains a predefined dataset of polar coordinates with values
  - Height map data from image (`heightmap.png`)
  - Dynamic oscilloscope data generated in Python

- **UI Components**:
  - `main.qml` - The main layout with tab navigation
  - `SurfaceHeightMap.qml` - Terrain visualization component
  - `SurfaceSpectrogram.qml` - Polar data visualization component
  - `SurfaceOscilloscope.qml` - Dynamic wave visualization component

## Technical Features

### Advanced Performance Optimizations

#### GPU Acceleration
The application uses OpenCL (when available) to leverage GPU computing power:

```python
class GPUDataGenerator:
    """Generates data using OpenCL (GPU acceleration) when available"""
    def __init__(self):
        # Initialize OpenCL context and command queue
        # ...
    
    def generate_data(self, row_count, col_count, x_min, x_max, y_min, y_max, z_min, z_max):
        # Execute OpenCL kernel to compute surface data on the GPU
        # ...
```

#### Memory Optimization
To reduce memory allocations and garbage collection overhead:

```python
def _pre_allocate_memory(self, rowCount, columnCount):
    """Pre-allocate memory for the reset arrays"""
    key = f"{rowCount}_{columnCount}"
    if key not in self.m_pre_allocated_arrays:
        # Pre-allocate arrays
        self.m_pre_allocated_arrays[key] = []
        for i in range(rowCount):
            row = [QSurfaceDataItem() for _ in range(columnCount)]
            self.m_pre_allocated_arrays[key].append(row)
```

#### Intelligent Data Caching
```python
# Check if we have the entire dataset cached
if cache_key in DATA_CACHE:
    with QMutexLocker(self.m_mutex):
        self.m_data = DATA_CACHE[cache_key]
        print("Using cached dataset")
        self.dataProgress.emit(100)
        self.dataReady.emit()
        return
```

#### Level of Detail (LOD)
```python
# Apply level of detail if needed
if self.m_lod_enabled and (rowCount > 100 or columnCount > 100):
    target_row_count = min(rowCount, 100)
    target_col_count = min(columnCount, 100)
    
    # Only apply LOD if we're significantly reducing the data
    if target_row_count * target_col_count < rowCount * columnCount * 0.7:
        print(f"Applying Level of Detail: {rowCount}x{columnCount} -> {target_row_count}x{target_col_count}")
        rowCount = target_row_count
        columnCount = target_col_count
```

### Multithreaded Architecture

The application uses a multithreaded approach to enhance performance:

- Worker threads generate surface data in parallel
- Thread pool manages optimal CPU utilization
- Thread-safe data exchange with the UI thread
- Progress indicators show when background processing is active

#### Key multithreading components:
```python
class DataGeneratorWorker(QRunnable):
    """Worker class for generating data in separate thread"""
    
    class Signals(QObject):
        finished = Signal(list, int)
        
    def __init__(self, row_start, row_count, column_count,
                 x_min, x_max, y_min, y_max, z_min, z_max, cache_index):
        # Worker initialization
        
    def run(self):
        # Perform data generation in separate thread
```

### Height Map Visualization

The height map visualization demonstrates:

- Loading terrain data from an image file (`heightmap.png`)
- Converting image data into a 3D surface using `HeightMapSurfaceDataProxy`
- Custom color gradients for terrain visualization
- User controls for toggling surface grid, flat shading, and background

#### Key code components:
```qml
HeightMapSurfaceDataProxy {
    heightMapFile: ":/qml/qmlsurfacegallery/heightmap.png"
    autoScaleY: true
    minYValue: 740
    maxYValue: 2787
    // Geographic coordinate mapping
    minZValue: -374 // ~ -39.374411"N
    maxZValue: -116 // ~ -39.115971"N
    minXValue: 472  // ~ 175.471767"E
    maxXValue: 781  // ~ 175.780758"E
}
```

### Spectrogram Visualization

The spectrogram visualization demonstrates:

- Using a ListModel as the data source for a 3D surface
- Switching between polar and Cartesian coordinate systems
- Orthographic projection for 2D-like views
- Custom color gradients for data representation

#### Key code components:
```qml
ItemModelSurfaceDataProxy {
    itemModel: surfaceData.model
    rowRole: "radius"
    columnRole: "angle"
    yPosRole: "value"
}
```

### Oscilloscope Visualization

The oscilloscope visualization demonstrates:

- Python-QML integration for dynamic data generation
- **Multithreaded data generation for improved performance**
- Real-time surface updates using timers
- Configurable sample rate and frequency settings
- Surface customization options (flat shading, grid lines)
- Status indicators for background thread operations

#### Key code components:
```qml
Timer {
    id: refreshTimer
    interval: 1000 / frequencySlider.value
    running: !oscilloscopeView.dataGenerating
    repeat: true
    onTriggered: dataSource.update(surfaceSeries);
}
```

```python
@QmlElement
class DataSource(QObject):
    dataReady = Signal()
    
    def __init__(self, parent=None):
        # Initialize thread pool and synchronization primitives
        self.m_thread_pool = QThreadPool.globalInstance()
        self.m_mutex = QMutex()
        
    def generateData(self, cacheCount, rowCount, columnCount,
                     xMin, xMax, yMin, yMax, zMin, zMax):
        # Distribute work among multiple threads
        
    def handleWorkerResult(self, cache_data, cache_index):
        # Collect results from worker threads
```

## Data Flow

1. **For the Height Map**:
   - The PNG image data is loaded via `HeightMapSurfaceDataProxy`
   - Y-values (height) are extracted from the image and scaled
   - The surface is rendered with a custom color gradient

2. **For the Spectrogram**:
   - The predefined model in `SpectrogramData.qml` provides data points
   - Each data point consists of radius, angle, and value properties
   - The data follows a mathematical pattern resembling sine waves

3. **For the Oscilloscope**:
   - The Python `DataSource` class dynamically generates data using multiple threads
   - Worker threads compute different portions of the data in parallel
   - Thread synchronization ensures data integrity
   - The timer in QML calls the `update()` method periodically
   - Surface visualization updates to show new data waves

## User Interface

The application provides various controls to manipulate the visualizations:

- **Height Map**:
  - Toggle surface grid display
  - Toggle between flat and smooth shading
  - Switch grid colors
  - Hide/show background
  
- **Spectrogram**:
  - Switch between polar and Cartesian coordinates
  - Toggle orthographic/perspective projection
  - Control grid and axis positions

- **Oscilloscope**:
  - Adjust sample count with a slider
  - Control update frequency
  - Toggle Level of Detail (LOD) for better performance
  - Clear data cache
  - Toggle display options
  - View FPS and data point information
  - Monitor data generation progress

## Dependencies

- **PySide6**: Qt for Python
- **Qt DataVisualization**: For 3D surface visualization
- **OpenGL**: Required for rendering (RHI backend)
- **NumPy**: For optimized numerical computations
- **PyOpenCL** (optional): For GPU-accelerated computations

## Running the Application

```bash
# Install dependencies
pip install PySide6 numpy
pip install pyopencl  # Optional, for GPU acceleration

# Run the application
python main.py
```

The application will launch with the OpenGL rendering backend. Navigate between the different visualizations using the tabs at the top of the window.

## Performance Tuning

You can enhance performance based on your specific hardware:

1. **GPU Acceleration**: If your system has a compatible GPU and PyOpenCL is installed, the application will automatically use GPU acceleration for data generation.

2. **Level of Detail**: Toggle the LOD switch to dynamically adjust the resolution of complex visualizations. This is particularly useful on lower-end hardware.

3. **Data Caching**: The application caches generated data to avoid redundant calculations. You can clear the cache using the "Clear Cache" button if needed.

4. **Thread Count**: The application automatically detects the optimal number of CPU threads, but you can adjust this in the code if needed.

## Key Features Demonstrated

- Integration of Python and QML
- 3D data visualization techniques
- **High-performance multithreaded and GPU-accelerated data processing**
- **Memory-efficient data handling and dynamic LOD**
- **Data caching and pre-allocation optimizations**
- Multiple data sources (static, dynamic, image-based)
- Interactive controls for visualization parameters
- Responsive design that adapts to portrait/landscape orientation
- Thread synchronization using Qt's concurrency primitives

1. Install virtual environment via virtualenv:

```bash
virtualenv venv or python3.12 -m venv venv
source venv/bin/activate
```

2. Install dependencies:
```bash
pip install -r requirements.txt
```

3. Generate resources:
```bash
pyside6-rcc qmlsurfacegallery.qrc -o rc_qmlsurfacegallery.py
```

4. Run the application:
```bash
python main.py
```

## Code Samples

1. https://code.qt.io/cgit/qt/qtdatavis3d.git/tree/examples/datavisualization?h=6.4.3
2. https://code.qt.io/cgit/qt/qtdatavis3d.git/tree/examples/datavisualization?h=6.9.0
3. https://doc.qt.io/qtforpython-6/examples/example_datavisualization_qmlsurfacegallery.html