#!/bin/bash


# Git initialisation script

# Parameters:

# -u username
# -e email address


#
#     _             _ _                                                    _                         _ _ _ _ 
#    | |           ( ) |                                                  | |                       | | | | |
#  __| | ___  _ __ |/| |_   _ __ _   _ _ __     __ _ ___   _ __ ___   ___ | |_   _   _ ___  ___ _ __| | | | |
# / _` |/ _ \| '_ \  | __| | '__| | | | '_ \   / _` / __| | '__/ _ \ / _ \| __| | | | / __|/ _ \ '__| | | | |
#| (_| | (_) | | | | | |_  | |  | |_| | | | | | (_| \__ \ | | | (_) | (_) | |_  | |_| \__ \  __/ |  |_|_|_|_|
# \__,_|\___/|_| |_|  \__| |_|   \__,_|_| |_|  \__,_|___/ |_|  \___/ \___/ \__|  \__,_|___/\___|_|  (_|_|_|_)
#

# Defining some general variables

RED='\033[0;31m' # Red colour
NC='\033[0m' # No colour

# Giving an initial messafe
echo -e "${RED}NOT TO USE FOR ROOT USER${NC}"
echo ""
echo ""
echo -e "${RED}Remember to use -u "\""username"\"" -e "\""email_address"\"" options${NC}"
sleep 10

# Retrieving parameters

if [ "$(whoami)" == "root" ]
	then echo "This script is not intended to be run as root user"
	exit
else
	while getopts u:e: option
	do
		case "${option}"
		in
		u) USER1=${OPTARG};;
		e) EMAIL1=${OPTARG};;
		esac
	done

	# Installing Git

	sudo apt install git

	echo -e "Git will be configured for user ${RED}$USER1${NC} and email address ${RED}$EMAIL1${NC}"
	sleep 10
	
	# Setting Git global user name

	echo "Setting $USERNAME1 as global Git user name"
	git config --global user.name "$USER1" --replace-all

	# Setting Git global email

	echo "Setting $EMAIL as global Git email address"
	git config --global user.email "$EMAIL1" --replace-all

	# Checking Git global values

	echo "Checking Git global values"
	git config --global user.name
	git config --global user.email
fi