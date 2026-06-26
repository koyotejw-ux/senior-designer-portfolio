import re

# Read as raw bytes
with open('server/data/db.json', 'rb') as f:
    raw = f.read()

# Replace sam_mes_finalff.jpg with sam_mes_final_final.jpg
old = b'sam_mes_finalff.jpg'
new = b'sam_mes_final_final.jpg'

count = raw.count(old)
print(f'Found {count} occurrences of {old}')

raw_updated = raw.replace(old, new)

# Write back
with open('server/data/db.json', 'wb') as f:
    f.write(raw_updated)

print('Done. db.json updated successfully.')
