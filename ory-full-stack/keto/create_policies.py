import requests

policies = [
  {
    "namespace": "app",
    "object": "subreddit",
    "relation": "edit",
    "subject_set": {
      "namespace": "groups",
      "object": "admin",
      "relation": "member"
    }
  },
  {
    "namespace": "app",
    "object": "subreddit",
    "relation": "create",
    "subject_set": {
      "namespace": "groups",
      "object": "admin",
      "relation": "member"
    }
  },
  {
    "namespace": "app",
    "object": "subreddit",
    "relation": "delete",
    "subject_set": {
      "namespace": "groups",
      "object": "admin",
      "relation": "member"
    }
  },
  {
    "namespace": "app",
    "object": "subreddit",
    "relation": "edit",
    "subject_set": {
      "namespace": "groups",
      "object": "moderator",
      "relation": "member"
    }
  },
  {
    "namespace": "app",
    "object": "subreddit",
    "relation": "create",
    "subject_set": {
      "namespace": "groups",
      "object": "moderator",
      "relation": "member"
    }
  }
]

for policy in policies:
    r = requests.put(
        "http://127.0.0.1:4467/relation-tuples",
        json=policy
    )
    if r.status_code != 201:
        print("Failed to create policy")
