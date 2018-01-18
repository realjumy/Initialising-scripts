#!/bin/bash


# Avoid SSH disconnection problems
# For its use with Ubuntu 16.04
# VERSION FOR THE CLIENT

# Defining some general variables

RED=$'\e[1;31m' # Red colour
GREEN=$'\e[1;32m' # Green colour
NC=$'\033[0m' # No colour

# Fix

echo -e "${RED}TO BE USED ONLY IN THE CLIENT!${NC}"
echo -e ""
echo -e "TO BE USED {RED}ONLY ONCE${NC}"
echo -e ""
read -p "Press any key to continue, or [CRTL]+C to cancel... " -n1 -s
echo -e " "

sudo echo "ServerAliveInterval 100" >> /etc/ssh/sshd_config

echo -e "${GREEN}Done!${NC}"