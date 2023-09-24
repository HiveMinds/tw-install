#!/bin/bash
. src/hardcoded_variables.txt
. src/helper.sh
. src/D_configure_taskserver.sh

# read hardcoded variables
SOURCE_DIR=$PWD

# get installation dependent parameters
LINUX_USERNAME=$(whoami)
#LINUX_GROUP=$(whoami)
echo "$LINUX_USERNAME"

# define the hostname
#IP=localhost # Worked after hostname -f did not work (anymore) (Did not work the first time after it worked)
#IP=localhost # did not work anymore after it stopped working and after hostname -f did not work anymore either
#IP=$(hostname -f) #yields: Can't use SSL_get_servername BUT IT DOES WORK!
#IP=$(hostname -f) #was connected but did not verify certificate
#IP=$(hostname -f) # Did not work anymore after localhost did not work anymore
IP=$(hostname -f)
#IP=0.0.0.0 # doesnt work
#IP=127.0.0.1 #Can't use SSL_get_servername
#IP=127.0.1.1 #Can't use SSL_get_servername
#IP=obfuscated ip4 #Can't use SSL_get_servername
#IP=192.168.2.219
echo "$IP"

# function to swap entire line in file that contains a substring
swap_line_containing_string() {
  local old_line_pattern=$1; shift
  local new_line=$1; shift
  local file=$1
  local new;
  new=$(echo "${new_line}" | sed 's/\//\\\//g')
  touch "${file}"
  sed -i '/'"${old_line_pattern}"'/{s/.*/'"${new}"'/;h};${x;/./{x;q100};x}' "${file}"
  
  # Check if the exit status of the previous command is not equal to 100
  # and if the variable ${new_line} is not an empty string
  if [[ $? -ne 100 ]] && [[ ${new_line} != '' ]]; then
    # If both conditions are met, append the value of ${new_line} to the
    # file specified by ${file}
    echo "${new_line}" >> "${file}"
  fi
}

# prepare for getting required dependencies
yes | sudo apt-get update

# install dependencies required for taskserver
yes | sudo apt install g++
yes | sudo apt install libgnutls28-dev
yes | sudo apt install uuid-dev
yes | sudo apt install cmake
yes | sudo apt install gnutls-bin

# install taskwarrior and add first task
yes | sudo apt install taskwarrior
yes | task add test task

# clone, build and install taskserver (taskd)
git clone --recursive https://github.com/GothenburgBitFactory/taskserver.git
cd taskserver || exit
cmake -DCMAKE_BUILD_TYPE=release .
make
yes | sudo make install


# #https://gitpitch.com/GothenburgBitFactory/taskserver-setup#/9/1
# set data folder that is used by taskserver
# TODO:move TASKDDATA variable definition to hardcoded.txt
export TASKDDATA=/var/taskd
sudo mkdir -p $TASKDDATA


# #https://gitpitch.com/GothenburgBitFactory/taskserver-setup#/9/2
# ensure the user can access the TASKDDATA directory
sudo chown -R "$LINUX_USERNAME" $TASKDDATA


# #https://gitpitch.com/GothenburgBitFactory/taskserver-setup#/9/3
# initialise the taskserver
taskd init


# #https://gitpitch.com/GothenburgBitFactory/taskserver-setup#/10/1
# replace the CN=localhost value in the vars file of the pki folder
# of the downloaded taskserver repository with the chosen hostname
# Note: the port is not included in the hostname
swap_line_containing_string "CN=" "CN=$IP" "$PWD/pki/vars"


# #https://gitpitch.com/GothenburgBitFactory/taskserver-setup#/10/3
# browse into the pki folder of the downloaded taskserver repo
cd "$PWD"/pki || exit

# generate the api, server and ca certificate files based on the
# pki/vars in the downloaded taskserver repo
./generate

# export the generated certificates to the taskserver datafolder
cp api.cert.pem $TASKDDATA
cp api.key.pem  $TASKDDATA
cp server.cert.pem $TASKDDATA
cp server.key.pem  $TASKDDATA
cp server.crl.pem  $TASKDDATA
cp ca.cert.pem     $TASKDDATA


#https://gitpitch.com/GothenburgBitFactory/taskserver-setup#/10/4
# configure the taskserver to use the generated certificates
taskd config --force client.cert $TASKDDATA/api.cert.pem
taskd config --force client.key  $TASKDDATA/api.key.pem
taskd config --force server.cert $TASKDDATA/server.cert.pem
taskd config --force server.key  $TASKDDATA/server.key.pem
taskd config --force server.crl  $TASKDDATA/server.crl.pem
taskd config --force ca.cert     $TASKDDATA/ca.cert.pem


#https://gitpitch.com/GothenburgBitFactory/taskserver-setup#/11
# Configure taskserver to create a log- and pid file
cd $TASKDDATA/.. || exit
# TODO: make this path dynamic based on TASKDDATA folder
# after the cleanup has been tested succesfully.
taskd config --force log /var/taskd.log
taskd config --force pid.file /var/taskd.pid

# specify hostname that the taskserver uses (including port)
# shellcheck disable=SC2086
taskd config --force server $IP:"$PORT"


#https://gitpitch.com/GothenburgBitFactory/taskserver-setup#/12
# ensure the parent directory of the TASKDDATA is accessible by user
# TODO: make this path dynamic based on TASKDDATA folder
# after the cleanup has been tested succesfully.
sudo chmod 7777 /var/

# start the taskserver (without sudo because the parent dir of the
# TASKDDATA folder is made accessible to the user
taskdctl start

# check the taskserver is running
ps -leaf | pgrep taskd


#https://gitpitch.com/GothenburgBitFactory/taskserver-setup#/12/1
#Is skipped till 12/5 systemd for at boot is done later
# TODO: implement taskdctl service at startup using systemd.service file


#https://gitpitch.com/GothenburgBitFactory/taskserver-setup#/14/1
# create an organisation for your taskserver (that can have
# one or more users)
taskd add org "$TW_ORGANISATION"


#https://gitpitch.com/GothenburgBitFactory/taskserver-setup#/14/2
# Add user to newly created taskwarrior organisation and export key
# shellcheck disable=SC2086
taskd add user $TW_ORGANISATION "$TW_USERNAME" > userkey.txt
# TODO: enable the user to add multiple taskwarrior users.
# TODO: read the key from terminal output file instead
# of from the organisation directory since that might
# contain multiple users already


#https://gitpitch.com/GothenburgBitFactory/taskserver-setup#/14/3
# generate a certificate for the newly added user
cd "$SOURCE_DIR"/taskserver/pki || exit
./generate.client first
# NOTE: There is no capital in this certificate name, because
# the certificate name does NOT have to match the actual username
# TODO: transform the certificate name from an absolute name to a variable


#https://gitpitch.com/GothenburgBitFactory/taskserver-setup#/15/4
# export the user- and ca certificate to taskwarrior directory
cp first.cert.pem ~/.task/
cp first.key.pem  ~/.task/
cp ca.cert.pem ~/.task/
# TODO: transform the certificate name from an absolute name the variable from 14/3
# TODO: read the taskwarrior directory from task diagnostics command
# TODO: make taskwarrior directory into variable
# TODO: change ~into an absolute path


#https://gitpitch.com/GothenburgBitFactory/taskserver-setup#/15/5
# configure taskwarrior to use taskd user- and ca certificates
# TODO: determine exactly what this does, e.g. does it
# configure taskwarrior and taskserver, or one or the other?
yes | task config taskd.certificate -- ~/.task/first.cert.pem
yes | task config taskd.key         -- ~/.task/first.key.pem
yes | task config taskd.ca          -- ~/.task/ca.cert.pem
# TODO: read the taskwarrior directory from task diagnostics command
# TODO: make taskwarrior directory into variable
# TODO: change ~into an absolute path


#https://gitpitch.com/GothenburgBitFactory/taskserver-setup#/15/6
# configure taskwarrior to use the hostname (and port) of the taskserver
yes | task config taskd.server      -- "$IP":"$PORT"

# configure taskwarrior to use the uuid from the newly created taskwarrior user
#read user id
echo "Please enter uuid"
USER_UUID=$(ls /var/taskd/orgs/"$TW_ORGANISATION"/users/)
echo "$USER_UUID"
yes | task config taskd.credentials -- "$TW_ORGANISATION"/"$TW_USERNAME"/"$USER_UUID"
# TODO: read the taskwarrior user uuid from file
# TODO: automatically enter the taskwarrior user uuid


#https://gitpitch.com/GothenburgBitFactory/taskserver-setup#/17
# Perform the first synchronisation between taskwarrior and taskserver
yes | task sync init


# Ensure the taskwarrior server is started upon reboot.
modify_taskd_service_file "$TASKDDATA"
copy_taskd_service_file
reload_deamon
start_taskd_server
check_status_taskd_server
enable_starting_taskd_server_at_boot

### Debugging:
# Check whether the hostname can validate the ca certificate.
openssl s_client -CAfile /home/"$LINUX_USERNAME"/.task/ca.cert.pem -host "$IP" -port "$PORT"

# verify whether each individual certificate is valid w.r.t. the ca certificate
certtool --verify --infile /home/"$LINUX_USERNAME"/.task/ca.cert.pem --load-ca-certificate /home/"$LINUX_USERNAME"/.task/ca.cert.pem
certtool --verify --infile /home/"$LINUX_USERNAME"/.task/first.cert.pem --load-ca-certificate /home/"$LINUX_USERNAME"/.task/ca.cert.pem

certtool --verify --infile /home/"$LINUX_USERNAME"/.task/ca.cert.pem --load-ca-certificate /var/taskd/ca.cert.pem
certtool --verify --infile /home/"$LINUX_USERNAME"/.task/first.cert.pem --load-ca-certificate /var/taskd/ca.cert.pem

certtool --verify --infile /var/taskd/api.cert.pem --load-ca-certificate /var/taskd/ca.cert.pem
certtool --verify --infile /var/taskd/server.cert.pem --load-ca-certificate /var/taskd/ca.cert.pem

# perform another form of certificate verification
certtool -i < /var/taskd/server.cert.pem | grep Subject:

# perform another form of certificate verification
openssl x509 -noout -in /var/taskd/server.cert.pem -subject


#https://gitpitch.com/GothenburgBitFactory/taskserver-troubleshooting#/3/4
# stop the taskserver and start it in debugging mode
#taskdctl stop
#taskd server --debug --debug.tls=2

# Open a new terminal and perform a task sync with the taskserver to
# see what happends in the taskserver
# task sync


# At this point in the code, it is at:
# /home/name/git/Hiveminds/tw-install/taskserver/pki 
# so it should go back to the SOURCE_DIR
cd $SOURCE_DIR && source src/run_taskserver_at_boot.sh
