import json
import os

import requests
from dateutil.parser import parse
from dotenv import load_dotenv

# Load Todoist secrets
load_dotenv(os.path.expanduser("~/.config/todoist.env"))
TODOIST_API_TOKEN = os.getenv("TODOIST_API_TOKEN")
assert TODOIST_API_TOKEN, "Missing Todoist API token"
TODOIST_PROJECT_ID = os.getenv("JIRA_PROJECT_ID")

# Load Jira secrets
load_dotenv(os.path.expanduser("~/.config/jira.env"))
JIRA_BASE_URL = os.getenv("JIRA_BASE_URL")
assert JIRA_BASE_URL, "Missing Jira base URL"
JIRA_USERNAME = os.getenv("JIRA_USERNAME")
assert JIRA_USERNAME, "Missing Jira username"
JIRA_API_TOKEN = os.getenv("JIRA_API_TOKEN")
assert JIRA_API_TOKEN, "Missing Jira API token"
JIRA_JQL = "assignee = currentUser() AND status not in (Backlog, Rejected, Done) ORDER BY dueDate ASC"


def get_jira_issues():
    """Fetch issues from Jira using the JQL query."""
    url = f"{JIRA_BASE_URL}/rest/api/2/search"
    headers = {"Content-Type": "application/json"}
    params = {
        "jql": JIRA_JQL,
        "fields": "summary,description,dueDate",  # Adjust fields as needed
    }
    response = requests.get(
        url,
        headers=headers,
        params=params,
        auth=(JIRA_USERNAME, JIRA_API_TOKEN),
        timeout=30,
    )
    response.raise_for_status()
    data = response.json()
    issues = data.get("issues", [])
    for issue in issues:
        print(f"Found Jira issue: {issue['key']}")
    return issues


def get_todoist_tasks():
    """Retrieve current Todoist tasks."""
    url = "https://api.todoist.com/rest/v2/tasks"
    headers = {"Authorization": f"Bearer {TODOIST_API_TOKEN}"}
    response = requests.get(url, headers=headers, timeout=30)
    response.raise_for_status()
    tasks = response.json()
    return tasks


def task_already_exists(jira_issue_key, todoist_tasks):
    """Check if a Todoist task already contains the Jira issue key."""
    for task in todoist_tasks:
        if jira_issue_key in task.get("content", ""):
            return True
    return False


def create_todoist_task(jira_issue, project_id=None):
    """Create a new task in Todoist based on a Jira issue."""
    jira_key = jira_issue["key"]
    fields = jira_issue["fields"]
    summary = fields.get("summary", "No Summary")
    description = fields.get("description", "")
    due_date = fields.get("dueDate", None)

    # Construct the task content: include the Jira issue key for future reference.
    task_content = f"{summary} [JIRA: {jira_key}]"
    task_url = f"{JIRA_BASE_URL}/browse/{jira_key}"
    task_payload = {
        "content": task_content,
        "description": f"{task_url}\n\n{description}",
    }

    if due_date:
        task_payload["due_string"] = due_date

    if project_id:
        task_payload["project_id"] = project_id

    url = "https://api.todoist.com/rest/v2/tasks"
    headers = {
        "Authorization": f"Bearer {TODOIST_API_TOKEN}",
        "Content-Type": "application/json",
    }
    response = requests.post(
        url, headers=headers, data=json.dumps(task_payload), timeout=30
    )
    response.raise_for_status()
    created_task = response.json()
    print(f"Created Todoist task for Jira issue {jira_key}: {created_task.get('id')}")
    return created_task


def sync_jira_to_todoist():
    print("Fetching Jira issues...")
    jira_issues = get_jira_issues()
    print(f"Found {len(jira_issues)} Jira issues.")

    print("Fetching existing Todoist tasks...")
    todoist_tasks = get_todoist_tasks()
    print(f"Found {len(todoist_tasks)} Todoist tasks.")

    # For each Jira issue, create a Todoist task if it doesn't already exist.
    new_tasks = 0
    for issue in jira_issues:
        jira_key = issue["key"]
        if not task_already_exists(jira_key, todoist_tasks):
            print(f"Creating Todoist task for Jira issue {jira_key}...")
            create_todoist_task(issue, project_id=TODOIST_PROJECT_ID)
            new_tasks += 1
        else:
            print(f"Todoist task for Jira issue {jira_key} already exists.")

    print(f"Sync complete. Created {new_tasks} new tasks in Todoist.")


if __name__ == "__main__":
    try:
        sync_jira_to_todoist()
    except Exception as e:
        print(f"An error occurred during sync: {e}")
