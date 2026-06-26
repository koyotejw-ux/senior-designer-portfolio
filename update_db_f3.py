import re

with open('server/data/db.json', 'rb') as f:
    raw = f.read()

old = b'sam_mes_final_final.jpg'
new = b'sam_mes_final3.jpg'

if old in raw:
    raw = raw.replace(old, new)
    with open('server/data/db.json', 'wb') as f:
        f.write(raw)
    print("db.json updated.")
else:
    print("old string not found.")
