#(Not the author) This script is designed to scan websites for directories using a word list.

#!/bin/env python3
import requests
URL = "http://192.168.141.21/"

#What the website will see when you login
user_agent = "Mozilla 5.0"
headers={
        "User-Agent": user_agent
}
#Reads word list named cat.txt to test those directory names
names = [line.strip() for line in open('cat.txt')]
for f in names:

        r=requests.get(URL+f,headers=headers)
        if r.status_code == requests.codes.ok:
                print("\033[0;32m/"+URL+f+"\033[0m")
        else:
                continue
