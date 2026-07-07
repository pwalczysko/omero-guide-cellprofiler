import tifffile

img = tifffile.imread("scripts/workspace/input/15019.tif")

print(img.shape)
print(img.dtype)