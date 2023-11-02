#!/bin/bash

# Define the log file path
LOG_FILE="/var/log/secure"

# Function to view all SSH logs
view_all_logs() {
  cat "$LOG_FILE"
  menu
}

# Function to view failed SSH login attempts
view_failed_attempts() {
  echo "Viewing failed SSH login attempts:"
  cat "$LOG_FILE" | grep "Failed password"
}

# Function to view successful SSH logins
view_accepted_logins() {
  echo "Viewing successful SSH logins:"
  cat "$LOG_FILE" | grep "Accepted"
}

# Function to remove a user and kill their session
remove_user() {
  read -p "Enter the username you want to remove: " username
  if id "$username" &>/dev/null; then
    # Kill user's session and processes
    pkill -u "$username"
    sleep 1  # Give some time for processes to terminate
    userdel -r "$username"
    echo "User '$username' has been removed."
  else
    echo "User '$username' does not exist."
  fi
}

# Function to add and block an IP using iptables
block_ip() {
  read -p "Enter the IP address you want to block: " ip_address
  # Add an iptables rule to block the IP address
  iptables -A INPUT -s "$ip_address" -j DROP
  echo "IP address '$ip_address' has been blocked with iptables."
}

# Main menu
menu() {
  while true; do
    echo "Options:"
    echo "1. View All SSH Logs"
    echo "2. View Failed SSH Login Attempts"
    echo "3. View Accepted SSH Logins"
    echo "4. Remove a User"
    echo "5. Block an IP with iptables"
    echo "6. Quit"
    read -p "Enter your choice: " choice

    case "$choice" in
      1)
        view_all_logs
        ;;
      2)
        view_failed_attempts
        ;;
      3)
        view_accepted_logins
        ;;
      4)
        remove_user
        ;;
      5)
        block_ip
        ;;
      6)
        echo "Exiting the script."
        exit 0
        ;;
      *)
        echo "Invalid option. Please choose a valid option."
        ;;
    esac
  done
}

# Start the menu
menu
