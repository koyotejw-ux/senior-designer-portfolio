import sys

with open('server/data/db.json', 'rb') as f:
    raw = f.read()

text = raw.decode('utf-8', errors='replace')

# Find p8 project
search = '"id": "p8"'
idx = text.find(search)
if idx < 0:
    print("p8 not found")
    sys.exit(1)

# find end - next project
search2 = '"id": "p7"'
end = text.find(search2, idx)
if end < 0:
    end = idx + 3000

chunk = text[idx:end]
sys.stdout.buffer.write(chunk.encode('utf-8', errors='replace'))
