#!/bin/bash


# Server initialisation script
# ~Ubuntu 16.04 version~

# Intended for a fresh installation of Ubuntu 16.04
# Intended to be run as root user

# Parameters:

# -u username

#                                                _                         _ _ _ _ 
#                                               | |                       | | | | |
# _ __ _   _ _ __     __ _ ___   _ __ ___   ___ | |_   _   _ ___  ___ _ __| | | | |
#| '__| | | | '_ \   / _` / __| | '__/ _ \ / _ \| __| | | | / __|/ _ \ '__| | | | |
#| |  | |_| | | | | | (_| \__ \ | | | (_) | (_) | |_  | |_| \__ \  __/ |  |_|_|_|_|
#|_|   \__,_|_| |_|  \__,_|___/ |_|  \___/ \___/ \__|  \__,_|___/\___|_|  (_|_|_|_)
#

# Defining some general variables

RED='\033[0;31m' # Red colour
NC='\033[0m' # No colour

# Retrieving parameters

while getopts u: option
do
	case "${option}"
	in
	u) USER1=${OPTARG};;
	esac
done

# Giving an initial messafe
echo -e "${RED}For its use in a clean Ubuntu 16.04 system${NC}"
echo ""
echo ""
echo -e "${RED}Remember to use -u username option${NC}"
sleep 10

# Updating and upgrading
echo -e "${RED}Updating and upgrading${NC}"
sudo apt update
sudo apt upgrade

# Installing some packages
echo -e "${RED}Installing some basic packages${NC}"
sudo apt install curl git

# Adding user
echo -e "Adding user ${RED}{$USER1}${NC} as ${RED}root${NC}"
adduser $USER1
usermod -aG sudo $USER1

# Creating RSA Key Pair
echo -e "${RED}Creating RSA Key Pair${NC}"
ssh-keygen -t rsa

# Installing Docker CE
echo -e "${RED}Installing Docker CE${NC}"

sudo apt remove docker docker-engine docker.io
sudo apt-get install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt update
sudo apt upgrade
sudo apt install docker-ce
sudo groupadd dockerexitr
sudo usermod -aG docker $USER1
sudo systemctl enable docker

# Installing Git
echo -e "${RED}Installing Git${NC}"
sudo apt install git

# Rebooting
echo -e "${RED}Rebooting in 10 seconds${NC}"
sleep 10
sudo reboot