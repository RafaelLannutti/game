import os
from PIL import Image, ImageDraw

villanos_dir = r"f:\UNAHUR\Objetos_I\TRES EMPANADAS\assets"

# Mapeo de direccion a nombre de archivo y offset para el "brazo" de ataque
# 1=Sur, 2=Norte, 3=Este, 4=Oeste
directions = {
    "1": ("1", "sur"),
    "2": ("2", "norte"),
    "3": ("3", "este"),
    "4": ("4", "oeste")
}

for dir_num, (name, cardinal) in directions.items():
    src_path = os.path.join(villanos_dir, f"demoledor{dir_num}A.png")
    dst_path = os.path.join(villanos_dir, f"demoledor{dir_num}C.png")
    
    if os.path.exists(src_path):
        img = Image.open(src_path).convert("RGBA")
        draw = ImageDraw.Draw(img)
        
        w, h = img.size
        # Draw a "fist" (red rectangle) depending on direction
        fist_size = 10
        if dir_num == "1": # Sur
            draw.rectangle([w//2 - fist_size//2, h - fist_size, w//2 + fist_size//2, h], fill=(255, 0, 0, 255))
        elif dir_num == "2": # Norte
            draw.rectangle([w//2 - fist_size//2, 0, w//2 + fist_size//2, fist_size], fill=(255, 0, 0, 255))
        elif dir_num == "3": # Este
            draw.rectangle([w - fist_size, h//2 - fist_size//2, w, h//2 + fist_size//2], fill=(255, 0, 0, 255))
        elif dir_num == "4": # Oeste
            draw.rectangle([0, h//2 - fist_size//2, fist_size, h//2 + fist_size//2], fill=(255, 0, 0, 255))
            
        img.save(dst_path)
        print(f"Created {dst_path}")
    else:
        print(f"File not found: {src_path}")
