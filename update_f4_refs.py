import os

files_to_update = [
    'lib/features/home/presentation/pages/project_detail_page.dart',
    'lib/features/portfolio/presentation/pages/project_detail_page.dart',
    'lib/features/home/data/providers/content_provider.dart',
    'server/data/db.json'
]

for file_path in files_to_update:
    if not os.path.exists(file_path):
        print(f"File not found: {file_path}")
        continue
        
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()
        
    # Replace the image references
    content = content.replace('sam_mes_f3_', 'sam_mes_f4_')
    content = content.replace('sam_mes_final3.jpg', 'sam_mes_final4.jpg')
    
    with open(file_path, 'w', encoding='utf-8') as f:
        f.write(content)
        
    print(f"Updated {file_path}")
