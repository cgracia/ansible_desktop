#!/bin/bash

OPTIONS="󰌃  Jira\n  Confluence\n  GitLab\n  Google\n󰭹  ER-ChatGPT\n 󰭹  ChatGPT"
ATLASSIAN_INSTANCE="energy-robotics.atlassian.net"
GITLAB_INSTANCE="gitlab.cicd.energy-robotics.com"
ER_CHATGPT="chat.energy-robotics.net"
CHATGPT="chatgpt.com"

CHOICE=$(echo -e "$OPTIONS" | rofi -dmenu -i -p " Search in:")

# Get Search Query
if [ -n "$CHOICE" ]; then
  QUERY=$(rofi -dmenu -p "Enter search term:")
  if [ -n "$QUERY" ]; then
    case "$CHOICE" in
    *"Jira")
      xdg-open "https://$ATLASSIAN_INSTANCE/issues/?jql=text~\"$QUERY\""
      ;;
    *"Confluence")
      xdg-open "https://$ATLASSIAN_INSTANCE/wiki/search?text=$QUERY"
      ;;
    *"GitLab")
      xdg-open "https://$GITLAB_INSTANCE/search?search=$QUERY"
      ;;
    *"Google")
      xdg-open "https://www.google.com/search?q=$QUERY"
      ;;
    *"ER-ChatGPT")
      xdg-open "https://$ER_CHATGPT/?q=$QUERY"
      ;;
    *"ChatGPT")
      xdg-open "https://$CHATGPT/?q=$QUERY"
      ;;
    *)
      notify-send "Unknown choice: $CHOICE" --icon "$HOME/dotfiles/failed_search.png"
      ;;
    esac
  fi
fi
