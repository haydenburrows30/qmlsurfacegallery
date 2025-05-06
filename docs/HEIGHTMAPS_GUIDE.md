# Height Maps Guide for QmlSurfaceGallery

## How to Load and Use Height Map Images

This guide explains how to successfully load and use height maps in the QmlSurfaceGallery application.

### What are Height Maps?

Height maps are grayscale images where:
- White pixels represent the highest elevations
- Black pixels represent the lowest elevations
- Gray pixels represent intermediate elevations

The application converts these brightness values to 3D elevation data.

### Ideal Height Map Characteristics

For best results, your height maps should have these properties:

1. **Grayscale** - The application reads brightness values, so proper grayscale images work best
2. **Sufficient Resolution** - Typical size is 256×256 to 1024×1024 pixels
3. **Proper Contrast** - Good range between darkest and lightest areas
4. **Lossless Format** - PNG is recommended to avoid compression artifacts
5. **Square Aspect Ratio** - While not required, square images tend to work best
6. **File Size** - Keep images under 1 GB in memory size to avoid allocation limits

### Loading External Height Maps

The application supports loading height maps from your local file system:

1. Click on the "Height Map" dropdown
2. Select "Browse..." from the dropdown menu
3. Navigate to and select your desired height map image
4. The application will attempt to load and display the image as a 3D surface

### Troubleshooting Height Map Loading

If your external height map doesn't display correctly:

1. **Format Issues** - Convert your image to PNG or another lossless format
2. **Size Issues** - Very large images may load slowly or use excessive memory
   - The application has a default limit of 1 GB for image loading
   - Images that require more memory will be rejected with an error message
   - For extremely large images, consider downsampling to a smaller resolution first
3. **Content Issues** - Some images may not have sufficient contrast to display well
4. **File Path Issues** - Ensure the path doesn't contain special characters

### Creating Your Own Height Maps

You can create your own height maps using:

1. **Image Editing Software** - Use Photoshop, GIMP or similar to create grayscale images
   - Apply gradients, filters and effects to create interesting landscapes
   - Save as PNG in grayscale mode

2. **Terrain Generation Software**:
   - World Machine
   - Terragen
   - L3DT

3. **Converting Real Elevation Data**:
   - USGS Earth Explorer (https://earthexplorer.usgs.gov/)
   - NASA SRTM data
   - Convert DEM files to grayscale images

### Example Transformations for Google Images

When downloading height maps from Google Images:

1. Convert to grayscale if in color
2. Adjust levels/contrast to use the full brightness range
3. Resize to a reasonable resolution (256×256 to 1024×1024)
4. Save in PNG format
5. Place the file in an accessible location on your computer

## Advanced Tips

- Smoother height maps produce smoother terrain
- Apply a slight blur to reduce noise in the visualization
- Adjust contrast to emphasize or de-emphasize elevation differences
- For performance reasons, smaller images (256×256) load and render faster

## Technical Limitations

### Image Size Limits

The application sets a memory allocation limit for image loading (default: 1 GB). If you receive an error like:

```
qt.gui.imageio: QImageReader: Rejecting image as it exceeds the current allocation limit
```

You have these options:

1. **Use a smaller image** - Reduce the resolution of your height map
2. **Increase the allocation limit** - If you have sufficient system memory, you can modify the source code in `main.py` to increase `QImageReader.setAllocationLimit()` to a higher value (in megabytes)
3. **Convert to a more efficient format** - Some image formats are more memory-efficient than others
