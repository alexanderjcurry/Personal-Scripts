#!/bin/bash

GREEN='\033[38;5;118m'
RED='\033[1;91m'
NC='\033[0m'

# Check if iptables is installed, and install it if it's not
if ! command -v iptables &> /dev/null; then
    read -p "iptables is not installed, would you like to install it? [y/n]: " choice
    case "$choice" in 
      y|Y )
        echo -e "${GREEN}Installing iptables...${NC}"
        dnf install -y iptables-services
        echo -e "${GREEN}iptables installed!${NC}"
        ;;
      n|N )
        echo -e "${RED}iptables is required for this script. Exiting.${NC}"
        exit 1
        ;;
      * )
        echo -e "${RED}Invalid option. iptables is required for this script. Exiting.${NC}"
        exit 1
        ;;
    esac
fi

sleep 2
clear

# Main menu
while true; do
    echo -e "\n${GREEN}What would you like to do?${NC}"
    echo "1. List current rules"
    echo "2. Add a port"
    echo "3. Remove a port"
    echo "4. Block a port"
    echo "5. Clear all rules"
    echo "6. Save current rules to a file"
    echo "7. Restore rules from a file"
    echo "8. Restart iptables"
    echo "9. Stop iptables"
    echo "10. Check status"
    echo "11. Quit"
    read -p "Please enter your choice: " choice
    case "$choice" in
      1 )
        echo -e "${GREEN}Current rules:${NC}"
        iptables -L
        ;;
      2 )
        read -p "Enter the port number you want to add: " port
        echo -e "${GREEN}Adding port $port...${NC}"
        iptables -A INPUT -p tcp --dport $port -j ACCEPT
        echo -e "${GREEN}Port $port added!${NC}"
        ;;
      3 )
        read -p "Enter the port number you want to remove: " port
        echo -e "${RED}Removing port $port...${NC}"
        iptables -D INPUT -p tcp --dport $port -j ACCEPT
        echo -e "${RED}Port $port removed!${NC}"
        ;;
      4 )
        read -p "Enter the port number you want to block: " port
        echo -e "${RED}Blocking port $port...${NC}"
        iptables -A INPUT -p tcp --dport $port -j DROP
        echo -e "${RED}Port $port blocked!${NC}"
        ;;
      5 )
        echo -e "${RED}Clearing all rules...${NC}"
        iptables -F
        echo -e "${RED}All rules cleared!${NC}"
        ;;
      6 )
        read -p "Enter the file name to save the rules to: " filename
        echo -e "${GREEN}Saving current rules to $filename...${NC}"
        iptables-save > $filename
        echo -e "${GREEN}Rules saved!${NC}"
        ;;
      7 )
        read -p "Enter the file name to restore the rules from: " filename
        echo -e "${RED}Restoring rules from $filename...${NC}"
        if [ -f "$filename" ]; then
iptables-restore < "$filename"
echo -e "${RED}Rules restored from $filename!${NC}"
else
echo -e "${RED}Error: File not found. Please enter a valid file name.${NC}"
fi
;;
8 )
echo -e "${GREEN}Restarting iptables service...${NC}"
systemctl restart iptables
echo -e "${GREEN}Iptables service restarted!${NC}"
;;
9 )
echo -e "${RED}Stopping iptables service...${NC}"
systemctl stop iptables
echo -e "${RED}Iptables service stopped!${NC}"
;;
10 )
echo -e "${GREEN}Checking iptables status...${NC}"
systemctl status iptables
;;
11 )
	echo -e "${GREEN}Exiting script...${NC}"
	exit 0
	;;
	* )
	echo -e "${RED}Invalid choice. Please enter a valid option.${NC}"
	;;
	esac
done

