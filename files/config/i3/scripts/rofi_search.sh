#!/bin/bash

OPTIONS="Jira\nConfluence\nGitLab\nGoogle\nAtlas"
ATLASSIAN_INSTANCE="energy-robotics.atlassian.net"
GITLAB_INSTANCE="gitlab.cicd.energy-robotics.com"

CHOICE=$(echo -e "$OPTIONS" | rofi -dmenu -i -p "Search in:")

# Get Search Query
if [ -n "$CHOICE" ]; then
    QUERY=$(rofi -dmenu -p "Enter search term:")
    if [ -n "$QUERY" ]; then
        case "$CHOICE" in
            "Jira")
                xdg-open "https://$ATLASSIAN_INSTANCE/issues/?jql=text~\"$QUERY\""
                ;;
            "Confluence")
                xdg-open "https://$ATLASSIAN_INSTANCE/wiki/search?text=$QUERY"
                ;;
            "GitLab")
                xdg-open "https://$GITLAB_INSTANCE/search?search=$QUERY"
                ;;
            "Google")
                xdg-open "https://www.google.com/search?q=$QUERY"
                ;;
            "Atlas")
                xdg-open "https://team.atlassian.com/projects?tql=(search%20LIKE%20%27$QUERY%27)&viewTab=all"
                ;;
            *)
                notify-send "Unknown choice: $CHOICE"
                ;;
        esac
    fi
fi
