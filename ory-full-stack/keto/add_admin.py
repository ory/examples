import sys
import requests

if len(sys.argv) < 2:
    print("Usage: add_admin.py email")
    sys.exit(1)

r = requests.put(
    "http://127.0.0.1:4467/relation-tuples",
    json={
        "namespace": "groups",
        "object": "admin",
        "relation": "member",
        "subject_id": sys.argv[1].replace("@", "")
    }
)

if r.status_code == 201:
    print("Admin created successfully")
