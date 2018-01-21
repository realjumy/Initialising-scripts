#!/bin/bash


# MongoDB 3.6 Docker initialisation script
# For its use with Ubuntu 16.04


#
#     _             _ _                                                    _                         _ _ _ _ 
#    | |           ( ) |                                                  | |                       | | | | |
#  __| | ___  _ __ |/| |_   _ __ _   _ _ __     __ _ ___   _ __ ___   ___ | |_   _   _ ___  ___ _ __| | | | |
# / _` |/ _ \| '_ \  | __| | '__| | | | '_ \   / _` / __| | '__/ _ \ / _ \| __| | | | / __|/ _ \ '__| | | | |
#| (_| | (_) | | | | | |_  | |  | |_| | | | | | (_| \__ \ | | | (_) | (_) | |_  | |_| \__ \  __/ |  |_|_|_|_|
# \__,_|\___/|_| |_|  \__| |_|   \__,_|_| |_|  \__,_|___/ |_|  \___/ \___/ \__|  \__,_|___/\___|_|  (_|_|_|_)
#


# Installing dependences

sudo apt install pwgen

# Defining some general variables

RED=$'\e[1;31m' # Red colour
GREEN=$'\e[1;32m' # Green colour
NC=$'\033[0m' # No colour
RANDOM1=${MONGODB_PASS:-$(pwgen -s 12 1)}
RANDOM2=${MONGODB_PASS:-$(pwgen -s 12 1)}

# Giving an initial messafe
echo -e "${RED}NOT TO USE FOR ROOT USER${NC}"
echo ""
echo ""
echo ""
echo ""
echo -e "${GREEN}___  ___                       ____________   _____   ____ "
echo -e "|  \/  |                       |  _  \ ___ \ |____ | / ___|"
echo -e "| .  . | ___  _ __   __ _  ___ | | | | |_/ /     / // /___ "
echo -e "| |\/| |/ _ \| '_ \ / _' |/ _ \| | | | ___ \     \ \| ___ "\\""
echo -e "| |  | | (_) | | | | (_| | (_) | |/ /| |_/ / .___/ /| \_/ |"
echo -e "\_|  |_/\___/|_| |_|\__, |\___/|___/ \____/  \____(_)_____/"
 echo -e "                    __/ |  "                               
echo -e "                   |___/   "
echo -e "${NC}"

sleep 5

# Asking usernames and database details
echo -e "In addition to the ${RED}admin${NC} user, an additional user and database will be created."
read -p "Enter the name of the additional user: " USER1
read -p "Enter the name of the additional database: " DATABASENAME
echo -e ""
echo -e "The user ${GREEN}$USER1${NC} and the ${GREEN}$DATABASENAME${NC} will be created in addition to ${RED}admin${NC}."
echo -e ""
read -p "Press any key to continue... " -n1 -s
echo -e " "

# Creating folders

echo -e "${GREEN}Creating required folders${NC}"
mkdir ~/docker_containers
mkdir ~/docker_containers/mongo
mkdir ~/docker_containers/mongo/data_folder
cd ~/docker_containers/mongo

echo -e "${GREEN}Starting the Docker container${NC}"

docker run --name mongodb -d -p 27017:27017 -v ~/docker_containers/mongo/data_folder:/data/db mongo:3.6 --auth

read -p "Press any key to continue... " -n1 -s
echo -e " "
clear
echo -e "${GREEN}Initialising MongoDB users and databases${NC}"
echo -e "Copy and paste the following for creating the admin user:"
echo -e ""
echo -e "db.createUser({ user: 'admin', pwd: '$RANDOM1', roles: [ { role: \"root\", db: \"admin\" } ] });"
echo -e "quit()"
echo -e ""
read -p "Press any key to continue... " -n1 -s
echo -e " "

docker exec -it mongodb mongo admin

read -p "Press any key to continue... " -n1 -s
echo -e " "

echo -e "Copy and paste the following for creating the app user and database:"
echo -e ""
echo -e "use $DATABASENAME"
echo -e "db.createUser({ user: 'app_admin', pwd: '$RANDOM2', roles: [ { role: \"dbOwner\", db: \"posts\" },{ role: \"readWrite\", db: \"locations\" } ] });"
echo -e "quit()"
echo -e ""
read -p "Press any key to continue... " -n1 -s
echo -e " "
docker exec -it mongodb mongo -u admin -p $RANDOM1 --authenticationDatabase admin

echo -e "${GREEN}DONE${NC}"
echo -e "Please, keep this information safe. Change the passwords as soon as you can."
echo -e ""
echo -e "Admin user: admin"
echo -e "Admin password: $RANDOM1"
echo -e ""
echo -e "Additional user name: $USER1"
echo -e "$USER1 password: $RANDOM2"
echo -e "Additional database name: $DATABASENAME"
