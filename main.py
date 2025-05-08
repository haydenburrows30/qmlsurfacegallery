from __future__ import annotations

"""PySide6 port of the Qt DataVisualization qmlsurfacegallery example from Qt v6.x"""

import os
import sys
from pathlib import Path

from PySide6.QtCore import QCoreApplication, QUrl
from PySide6.QtGui import QGuiApplication, QImageReader, QSurfaceFormat
from PySide6.QtQml import QQmlApplicationEngine

from datasource import DataSource
import rc_qmlsurfacegallery


def main():
    os.environ["QSG_RHI_BACKEND"] = "opengl"
    app = QGuiApplication(sys.argv)

    # Set image allocation limit to a very high value for large heightmap images
    QImageReader.setAllocationLimit(1024 * 1024 * 100)  # 100MB limit

    engine = QQmlApplicationEngine()

    # Add QML import path
    qml_path = Path(__file__).resolve().parent / "qml"
    engine.addImportPath(str(qml_path))

    # Enable antialiasing in direct rendering mode
    surface_format = QSurfaceFormat()
    surface_format.setSamples(8)  # Set antialiasing (8x MSAA)
    surface_format.setDepthBufferSize(24)
    QSurfaceFormat.setDefaultFormat(surface_format)

    QCoreApplication.setApplicationName("Surface Graph Gallery")

    qml_file = Path(__file__).resolve().parent / "qml" / "qmlsurfacegallery" / "main.qml"
    # Load the QML file
    engine.load(QUrl.fromLocalFile(qml_file))
    if not engine.rootObjects():
        return -1
    return app.exec()

if __name__ == "__main__":
    sys.exit(main())