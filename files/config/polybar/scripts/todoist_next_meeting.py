#!/usr/bin/env python3

import datetime
import os
import sys

import requests


# Load API token from ~/.config/todoist.env
def load_env():
    env_path = os.path.expanduser("~/.config/todoist.env")
    env_vars = {}
    if os.path.exists(env_path):
        with open(env_path, "r", encoding="utf-8") as f:
            for line in f:
                key, value = line.strip().split("=", 1)
                env_vars[key] = value
    return env_vars


env_vars = load_env()
TODOIST_API_TOKEN = env_vars.get("TODOIST_API_TOKEN")
PROJECT_ID = env_vars.get("MEETINGS_PROJECT_ID")


if not TODOIST_API_TOKEN or not PROJECT_ID:
    print("Error: Missing Todoist API token or project ID")
    sys.exit(1)


# Get tasks from the #meetings project
def get_next_meeting():
    headers = {"Authorization": f"Bearer {TODOIST_API_TOKEN}"}
    url = f"https://api.todoist.com/rest/v2/tasks?project_id={PROJECT_ID}"
    response = requests.get(url, headers=headers, timeout=30)

    if response.status_code != 200:
        return "Error fetching tasks"

    tasks = response.json()

    meetings = [t for t in tasks if t.get("due")]
    meetings = [t for t in meetings if t["due"].get("datetime") or t["due"].get("date")]

    if not meetings:
        return "No meetings found"

    meetings.sort(key=lambda t: t["due"].get("datetime") or t["due"].get("date"))

    next_meeting = meetings[0]
    meeting_time = next_meeting["due"]["datetime"] or next_meeting["due"]["date"]
    task_id = next_meeting["id"]

    now = datetime.datetime.now(datetime.timezone.utc)
    meeting_dt = datetime.datetime.fromisoformat(meeting_time).replace(
        tzinfo=datetime.timezone.utc
    )

    delta = meeting_dt - now
    if delta.total_seconds() < 0:
        color = "%{F#ff0000}"  # Red (overdue)
    elif delta.total_seconds() < 1800:
        color = "%{F#ffcc00}"  # Yellow (less than 30 minutes)
    else:
        color = "%{F#ffffff}"  # White (normal)

    title = next_meeting["content"]

    # If meeting is not today, show the weekday as well
    if meeting_dt.date() != now.date():
        title = f"{meeting_dt.strftime('%A')}: {title}"

    return task_id, f"{color}{title} at {meeting_dt.strftime('%H:%M')}%{{F-}}"


def complete_task():
    task_id, _ = get_next_meeting()
    if not task_id:
        print("No task to complete")
        return

    url = f"https://api.todoist.com/rest/v2/tasks/{task_id}/close"
    headers = {"Authorization": f"Bearer {TODOIST_API_TOKEN}"}
    response = requests.post(url, headers=headers, timeout=30)

    if response.status_code == 204:
        print("Task completed")
    else:
        print("Error completing task", response.text)


if __name__ == "__main__":
    if len(sys.argv) > 1 and sys.argv[1] == "complete":
        complete_task()
    else:
        _, display_text = get_next_meeting()
        print(display_text)
