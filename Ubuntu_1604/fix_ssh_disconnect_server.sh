#!/bin/bash


# Avoid SSH disconnection problems
# For its use with Ubuntu 16.04
# VERSION FOR THE SERVER

# Defining some general variables

RED=$'\e[1;31m' # Red colour
GREEN=$'\e[1;32m' # Green colour
NC=$'\033[0m' # No colour

# Fix

echo -e "${RED}TO BE USED ONLY IN THE SERVER!${NC}"
echo -e ""
echo -e "TO BE USED {RED}ONLY ONCE${NC}"
echo -e ""
read -p "Press any key to continue, or [CRTL]+C to cancel... " -n1 -s
echo -e " "

sudo echo "ClientAliveInterval 60" >> /etc/ssh/sshd_config
sudo echo "TCPKeepAlive yes" >> /etc/ssh/sshd_config
sudo echo "ClientAliveCountMax 10000" >> /etc/ssh/sshd_config

echo -e "${GREEN}Done!${NC}"