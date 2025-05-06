# Copyright (C) 2023 The Qt Company Ltd.
# SPDX-License-Identifier: LicenseRef-Qt-Commercial OR BSD-3-Clause

from PySide6.QtCore import QObject, QDate, QDateTime, QTime, Signal, Property
from PySide6.QtDataVisualization import QValue3DAxisFormatter

# One day in milliseconds
ONE_DAY_MS = 60.0 * 60.0 * 24.0 * 1000.0

class CustomFormatter(QValue3DAxisFormatter):
    originDateChanged = Signal(QDate)
    selectionFormatChanged = Signal(str)
    
    def __init__(self, parent=None):
        super().__init__(parent)
        self.__originDate = QDate()
        self.__selectionFormat = ""
    
    def createNewInstance(self):
        return CustomFormatter()
    
    def populateCopy(self, copy):
        super().populateCopy(copy)
        
        customFormatter = copy
        customFormatter.__originDate = self.__originDate
        customFormatter.__selectionFormat = self.__selectionFormat
    
    def recalculate(self):
        # We want our axis to always have gridlines at date breaks
        
        # Convert range into QDateTimes
        minTime = self.valueToDateTime(float(self.axis().min()))
        maxTime = self.valueToDateTime(float(self.axis().max()))
        
        # Find out the grid counts
        midnight = QTime(0, 0)
        minFullDate = QDateTime(minTime.date(), midnight)
        gridCount = 0
        if minFullDate != minTime:
            minFullDate = minFullDate.addDays(1)
        maxFullDate = QDateTime(maxTime.date(), midnight)
        
        gridCount += minFullDate.daysTo(maxFullDate) + 1
        subGridCount = self.axis().subSegmentCount() - 1
        
        # Reserve space for position arrays and label strings
        self.gridPositions().resize(gridCount)
        self.subGridPositions().resize((gridCount + 1) * subGridCount)
        self.labelPositions().resize(gridCount)
        self.labelStrings().clear()
        
        # Calculate positions and format labels
        startMs = minTime.toMSecsSinceEpoch()
        endMs = maxTime.toMSecsSinceEpoch()
        dateNormalizer = endMs - startMs
        firstLineOffset = (minFullDate.toMSecsSinceEpoch() - startMs) / dateNormalizer
        segmentStep = ONE_DAY_MS / dateNormalizer
        subSegmentStep = 0
        
        if subGridCount > 0:
            subSegmentStep = segmentStep / float(subGridCount + 1)
        
        for i in range(gridCount):
            gridValue = firstLineOffset + (segmentStep * float(i))
            self.gridPositions()[i] = float(gridValue)
            self.labelPositions()[i] = float(gridValue)
            self.labelStrings().append(minFullDate.addDays(i).toString(self.axis().labelFormat()))
        
        for i in range(gridCount + 1):
            if self.subGridPositions().size() > 0:
                for j in range(subGridCount):
                    position = 0.0
                    if i:
                        position = self.gridPositions()[i - 1] + subSegmentStep * (j + 1)
                    else:
                        position = self.gridPositions()[0] - segmentStep + subSegmentStep * (j + 1)
                    
                    if position > 1.0 or position < 0.0:
                        position = self.gridPositions()[0]
                    
                    self.subGridPositions()[i * subGridCount + j] = position
    
    def stringForValue(self, value, format):
        # Unused format parameter
        return self.valueToDateTime(value).toString(self.__selectionFormat)
    
    def originDate(self):
        return self.__originDate
    
    def selectionFormat(self):
        return self.__selectionFormat
    
    def setOriginDate(self, date):
        if self.__originDate != date:
            self.__originDate = date
            self.markDirty(True)
            self.originDateChanged.emit(date)
    
    def setSelectionFormat(self, format):
        if self.__selectionFormat != format:
            self.__selectionFormat = format
            self.markDirty(True)  # Necessary to regenerate already visible selection label
            self.selectionFormatChanged.emit(format)
    
    def valueToDateTime(self, value):
        return self.__originDate.startOfDay().addMSecs(int(ONE_DAY_MS * value))
    
    # Property definitions for QML
    origin_date = Property(QDate, originDate, setOriginDate, notify=originDateChanged)
    selection_format = Property(str, selectionFormat, setSelectionFormat, notify=selectionFormatChanged)
