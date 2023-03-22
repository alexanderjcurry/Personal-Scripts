#!/bin/bash

function quick_scan {
  nmap -sS -T4 -F -oN nmap_quick_scan.txt $target_ip_address
}

function stealthy_scan {
  nmap -sS -sV -p- -T2 -n -Pn --min-rate 1000 -oN nmap_stealth_scan.txt $target_ip_address
}

function deep_scan {
  nmap -sS -sV -sC -O -A -T4 -p- --script vuln -oN nmap_deep_scan.txt $target_ip_address
}

read -p "Enter target IP address: " target_ip_address

echo "Which nmap scan would you like to run?"
select scan_type in "Quick Scan" "Stealthy Scan" "Super In-Depth Scan" "Quit"; do
  case $scan_type in
    "Quick Scan")
      quick_scan
      break
      ;;
    "Stealthy Scan")
      stealthy_scan
      break
      ;;
    "Super In-Depth Scan")
      deep_scan
      break
      ;;
    "Quit")
      exit
      ;;
    *) echo "Invalid option";;
  esac
done

