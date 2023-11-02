#!/bin/bash

# Define the log file path
LOG_FILE="/var/log/secure"

# Function to display the main menu
display_menu() {
  echo "Options:"
  echo "1. View All SSH Logs"
  echo "2. View Failed SSH Login Attempts"
  echo "3. View Accepted SSH Logins"
  echo "4. Remove a User"
  echo "5. Block an IP with iptables"
  echo "6. Quit"
}

# Function to view all SSH logs
view_all_logs() {
  echo "Viewing all SSH logs:"
  cat "$LOG_FILE"
  read -p "Press Enter to return to the menu..."
}

# Function to view failed SSH login attempts
view_failed_attempts() {
  echo "Viewing failed SSH login attempts:"
  grep "Failed password" "$LOG_FILE"
  read -p "Press Enter to return to the menu..."
}

# Function to view successful SSH logins
view_accepted_logins() {
  echo "Viewing successful SSH logins:"
  grep "Accepted" "$LOG_FILE"
  read -p "Press Enter to return to the menu..."
}

# Function to remove a user and kill their session
remove_user() {
  read -p "Enter the username you want to remove: " username
  if [ -z "$username" ]; then
    echo "Username cannot be empty."
    read -p "Press Enter to continue..."
    return
  fi

  if id "$username" &>/dev/null; then
    # Confirm user deletion
    read -p "Are you sure you want to remove user '$username'? (y/n): " confirm
    if [ "$confirm" = "y" ]; then
      # Kill user's session and processes
      pkill -u "$username"
      sleep 1  # Give some time for processes to terminate
      userdel -r "$username"
      echo "User '$username' has been removed."
    else
      echo "User removal canceled."
    fi
  else
    echo "User '$username' does not exist."
  fi

  read -p "Press Enter to return to the menu..."
}

# Function to add and block an IP using iptables
block_ip() {
  read -p "Enter the IP address you want to block: " ip_address
  if [ -z "$ip_address" ]; then
    echo "IP address cannot be empty."
    read -p "Press Enter to continue..."
    return
  fi

  # Confirm IP blocking
  read -p "Are you sure you want to block IP address '$ip_address' with iptables? (y/n): " confirm
  if [ "$confirm" = "y" ]; then
    # Add an iptables rule to block the IP address
    iptables -A INPUT -s "$ip_address" -j DROP
    echo "IP address '$ip_address' has been blocked with iptables."
  else
    echo "IP blocking canceled."
  fi

  read -p "Press Enter to return to the menu..."
}

# Function to quit the script
quit() {
  clear
  echo "Exiting the script."
  exit 0
}

# Function to handle invalid options
invalid_option() {
  echo "Invalid option. Please choose a valid option."
  read -p "Press Enter to continue..."
}

# Main menu
menu() {
  clear  # Clear the screen once before entering the menu loop
  while true; do
    display_menu
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
        quit
        ;;
      *)
        invalid_option
        ;;
    esac
  done
}

# Start the menu
menu
