import os
from PIL import Image

# Set image bomb limits larger to avoid DecompressionBombError
Image.MAX_IMAGE_PIXELS = None

img_path = 'assets/images/sam_mes_final4.jpg'
out_dir = 'assets/images'
server_dir = 'server/data/images'

img = Image.open(img_path)
width, height = img.size
# Let's slice it into 8 parts based on height.
slice_height = height // 8

for i in range(8):
    box = (0, i * slice_height, width, (i + 1) * slice_height)
    sliced_img = img.crop(box)
    
    filename = f'sam_mes_f4_{i+1}.jpg'
    
    # Save to assets
    sliced_img.save(os.path.join(out_dir, filename), quality=90)
    
    # Save to server
    sliced_img.save(os.path.join(server_dir, filename), quality=90)
    
print("Slicing complete.")
