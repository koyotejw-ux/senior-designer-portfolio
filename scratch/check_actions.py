import urllib.request
import json

url = "https://api.github.com/repos/koyotejw-ux/senior-designer-portfolio/actions/runs?per_page=5"
req = urllib.request.Request(
    url, 
    headers={'User-Agent': 'Mozilla/5.0'}
)

try:
    with urllib.request.urlopen(req) as response:
        data = json.loads(response.read().decode())
        for run in data.get('workflow_runs', []):
            print(f"ID: {run['id']}, Name: {run['name']}, Event: {run['event']}, Status: {run['status']}, Conclusion: {run['conclusion']}, Commit: {run['head_commit']['message'][:50]}")
except Exception as e:
    print("Error:", e)
