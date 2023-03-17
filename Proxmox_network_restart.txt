#Designed to bring ifdown then wait 10 seconds to bring it up. This was used to restart the network settings quickly on proxmox so when you lose connection you dont have to manually go bring it back up.

#!/bin/bash

echo "Bringing down interface eno1..."
ifdown eno1

echo "Waiting for 10 seconds..."
sleep 10

echo "Bringing up interface eno1..."
ifup eno1
