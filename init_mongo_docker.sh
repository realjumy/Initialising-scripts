#!/bin/bash


# MongoDB 3.6 Docker initialisation script

# Parameters:

# -u username


#
#     _             _ _                                                    _                         _ _ _ _ 
#    | |           ( ) |                                                  | |                       | | | | |
#  __| | ___  _ __ |/| |_   _ __ _   _ _ __     __ _ ___   _ __ ___   ___ | |_   _   _ ___  ___ _ __| | | | |
# / _` |/ _ \| '_ \  | __| | '__| | | | '_ \   / _` / __| | '__/ _ \ / _ \| __| | | | / __|/ _ \ '__| | | | |
#| (_| | (_) | | | | | |_  | |  | |_| | | | | | (_| \__ \ | | | (_) | (_) | |_  | |_| \__ \  __/ |  |_|_|_|_|
# \__,_|\___/|_| |_|  \__| |_|   \__,_|_| |_|  \__,_|___/ |_|  \___/ \___/ \__|  \__,_|___/\___|_|  (_|_|_|_)
#

# Defining some general variables

RED=$'\e[1;31m' # Red colour
GREEN=$'\e[1;32m' # Green colour
NC=$'\033[0m' # No colour
RANDOM1=`date +%s|sha256sum|base64|head -c 32`
RANDOM2=`date +%s|sha256sum|base64|head -c 32`
unset USER1

# Retrieving parameters

while getopts u: option
do
	case "${option}"
	in
	u) USER1=${OPTARG};;
	esac
done

# Creating user in case is left empty

if [ -z "$USER1" ]
then
   USER1="test-app"
fi

# Giving an initial messafe
echo -e "${RED}NOT TO USE FOR ROOT USER${NC}"
echo ""
echo ""
echo -e "${RED}Remember to use -u "\""username"\"" ${NC}"
echo ""
echo ""
echo -e "Based on the information available at http://blog.bejanalex.com/2017/03/running-mongodb-in-a-docker-container-with-authentication/"

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

# Creating folders

mkdir ~/docker_containers
mkdir ~/docker_containers/mongo
mkdir ~/docker_containers/mongo/data_folder
cd ~/docker_containers/mongo
touch Dockerfile
touch run.sh
chmod +x run.sh
touch set_mongodb_password.sh
chmod +x set_mongodb_password.sh

# Adding content to Dockerfile

echo "FROM mongo:3.6" >> Dockerfile
echo " " >> Dockerfile
echo "MAINTAINER <Alex Bejan> contact@bejanalex.com" >> Dockerfile
echo " " >> Dockerfile
echo "ENV AUTH yes" >> Dockerfile
echo "ENV STORAGE_ENGINE wiredTiger" >> Dockerfile
echo "ENV JOURNALING yes" >> Dockerfile
echo " " >> Dockerfile
echo "ADD run.sh /run.sh" >> Dockerfile
echo "ADD set_mongodb_password.sh /set_mongodb_password.sh" >> Dockerfile
echo " " >> Dockerfile
echo "CMD ["/run.sh"]" >> Dockerfile

# Adding content to run.sh

echo "#!/bin/bash" >> run.sh
echo "set -m" >> run.sh
echo " " >> run.sh
echo "mongodb_cmd=\"mongod --storageEngine $STORAGE_ENGINE\"" >> run.sh
echo "cmd=\"$mongodb_cmd --master\"" >> run.sh
echo "if [ \"$AUTH\" == \"yes\" ]; then" >> run.sh
echo "    cmd=\"$cmd --auth\"" >> run.sh
echo "fi" >> run.sh
echo " " >> run.sh
echo "if [ \"$JOURNALING\" == \"no\" ]; then" >> run.sh
echo "    cmd=\"$cmd --nojournal\"" >> run.sh
echo "fi" >> run.sh
echo " " >> run.sh
echo "if [ \"$OPLOG_SIZE\" != \"\" ]; then" >> run.sh
echo "    cmd=\"$cmd --oplogSize $OPLOG_SIZE\"" >> run.sh
echo "fi" >> run.sh
echo " " >> run.sh
echo "$cmd &" >> run.sh
echo " " >> run.sh
echo "if [ ! -f /data/db/.mongodb_password_set ]; then" >> run.sh
echo "    /set_mongodb_password.sh" >> run.sh
echo "fi" >> run.sh
echo " " >> run.sh
echo "fg" >> run.sh

# Adding content to set_mongodb_password.sh

echo "#!/bin/bash" >> set_mongodb_password.sh
echo " " >> set_mongodb_password.sh
echo "# Admin User" >> set_mongodb_password.sh
echo "MONGODB_ADMIN_USER=${MONGODB_ADMIN_USER:-\"admin\"}" >> set_mongodb_password.sh
echo "MONGODB_ADMIN_PASS=${MONGODB_ADMIN_PASS:-\"${RANDOM1}\"}" >> set_mongodb_password.sh
echo " " >> set_mongodb_password.sh
echo "# Application Database User" >> set_mongodb_password.sh
echo "MONGODB_APPLICATION_DATABASE=${MONGODB_APPLICATION_DATABASE:-\"admin\"}" >> set_mongodb_password.sh
echo "MONGODB_APPLICATION_USER=${MONGODB_APPLICATION_USER:-\"${USER1}\"}" >> set_mongodb_password.sh
echo "MONGODB_APPLICATION_PASS=${MONGODB_APPLICATION_PASS:-\"${RANDOM2}\"}" >> set_mongodb_password.sh
echo " " >> set_mongodb_password.sh
echo "# Wait for MongoDB to boot" >> set_mongodb_password.sh
echo "RET=1" >> set_mongodb_password.sh
echo "while [[ RET -ne 0 ]]; do" >> set_mongodb_password.sh
echo "    echo \"=> Waiting for confirmation of MongoDB service startup...\"" >> set_mongodb_password.sh
echo "    sleep 5" >> set_mongodb_password.sh
echo "    mongo admin --eval \"help\" >/dev/null 2>&1" >> set_mongodb_password.sh
echo "    RET=$?" >> set_mongodb_password.sh
echo "done" >> set_mongodb_password.sh
echo " " >> set_mongodb_password.sh
echo "# Create the admin user" >> set_mongodb_password.sh
echo "echo \"=> Creating admin user with a password in MongoDB\"" >> set_mongodb_password.sh
echo "mongo admin --eval \"db.createUser({user: '$MONGODB_ADMIN_USER', pwd: '$MONGODB_ADMIN_PASS', roles:[{role:'root',db:'admin'}]});\"" >> set_mongodb_password.sh
echo " " >> set_mongodb_password.sh
echo "sleep 3" >> set_mongodb_password.sh
echo " " >> set_mongodb_password.sh
echo "# If we've defined the MONGODB_APPLICATION_DATABASE environment variable and it's a different database" >> set_mongodb_password.sh
echo "# than admin, then create the user for that database." >> set_mongodb_password.sh
echo "# First it authenticates to Mongo using the admin user it created above." >> set_mongodb_password.sh
echo "# Then it switches to the REST API database and runs the createUser command " >> set_mongodb_password.sh
echo "# to actually create the user and assign it to the database." >> set_mongodb_password.sh
echo "if [ \"$MONGODB_APPLICATION_DATABASE\" != \"admin\" ]; then" >> set_mongodb_password.sh
echo "    echo \"=> Creating an ${MONGODB_APPLICATION_DATABASE} user with a password in MongoDB\"" >> set_mongodb_password.sh
echo "    mongo admin -u $MONGODB_ADMIN_USER -p $MONGODB_ADMIN_PASS << EOF" >> set_mongodb_password.sh
echo "use $MONGODB_APPLICATION_DATABASE" >> set_mongodb_password.sh
echo "db.createUser({user: '$MONGODB_APPLICATION_USER', pwd: '$MONGODB_APPLICATION_PASS', roles:[{role:'dbOwner', db:'$MONGODB_APPLICATION_DATABASE'}]})" >> set_mongodb_password.sh
echo "EOF" >> set_mongodb_password.sh
echo "fi" >> set_mongodb_password.sh
echo " " >> set_mongodb_password.sh
echo "sleep 1" >> set_mongodb_password.sh
echo " " >> set_mongodb_password.sh
echo "# If everything went well, add a file as a flag so we know in the future to not re-create the" >> set_mongodb_password.sh
echo "# users if we're recreating the container (provided we're using some persistent storage)" >> set_mongodb_password.sh
echo "echo \"=> Done!\"" >> set_mongodb_password.sh
echo "touch /data/db/.mongodb_password_set" >> set_mongodb_password.sh
echo " " >> set_mongodb_password.sh
echo "echo \"========================================================================\"" >> set_mongodb_password.sh
echo "echo \"You can now connect to the admin MongoDB server using:\"" >> set_mongodb_password.sh
echo "echo \"\"" >> set_mongodb_password.sh
echo "echo \"    mongo admin -u $MONGODB_ADMIN_USER -p $MONGODB_ADMIN_PASS --host <host> --port <port>\"" >> set_mongodb_password.sh
echo "echo \"\"" >> set_mongodb_password.sh
echo "echo \"Please remember to change the admin password as soon as possible!\"" >> set_mongodb_password.sh
echo "echo \"========================================================================\"" >> set_mongodb_password.sh

read -p "Press any key to continue... " -n1 -s

# Creating the Docker image

echo "admin password: ${RANDOM1}"
echo "${USER1} password: ${RANDOM2}"
echo "MONGODB_APPLICATION_DATABASE=mytestdatabase"
read -p "Press any key to continue... " -n1 -s
echo ""
echo -e "${GREEN}Creating the docker image...${NC}"
docker build -t alexpunct/mongo:3.6 .

# Starting
echo -e "${GREEN}Starting MongoDB${NC}"

docker run -it -e MONGODB_ADMIN_USER=admin -e MONGODB_ADMIN_PASS=${RANDOM1} -e MONGODB_APPLICATION_DATABASE=mytestdatabase -e MONGODB_APPLICATION_USER=${USER1} -e MONGODB_APPLICATION_PASS=${RANDOM2} -p 27017:27017 -v ~/docker_containers/mongo/data_folder:/data/db alexpunct/mongo:3.6 --auth