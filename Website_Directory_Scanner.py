#!/bin/env python3
import requests

print("This script is designed to scan a website for directories using a word list. It prompts the user to enter the website URL and the filename of the word list to use. The script then reads the word list and tests each directory name against the website by sending HTTP GET requests. If a directory is found, it prints the directory name in green. Otherwise, it continues to the next directory name in the word list.\n \n")

# Prompt for website URL
URL = input("Enter the website URL: ")

# Check if URL has http:// or https:// prefix, add it if missing
if not URL.startswith("http://") and not URL.startswith("https://"):
    URL = "http://" + URL

# Prompt for word list filename
word_list_filename = input("Enter the word list filename: ")

#What the website will see when you login
user_agent = "Mozilla 5.0"
headers={
        "User-Agent": user_agent
}

#Reads word list to test those directory names
names = [line.strip() for line in open(word_list_filename)]

for f in names:
    r=requests.get(URL+"/"+f,headers=headers)
    if r.status_code == requests.codes.ok:
        print("\033[0;32m/"+URL+"/"+f+"\033[0m")
    else:
        continue

