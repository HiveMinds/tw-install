#!/bin/sh
mkdir_taskddata() {
	TASKDDATA=$1
	output=$(mkdir -p $TASKDDATA)
	echo $output
	# TODO: test whether the folder did not already exist
}


mkdir_taskddata_pki() {
	TASKDDATA=$1
	output=$(mkdir -p $TASKDDATA/pki)
	echo $output
	# TODO: test whether the folder did not already exist
}


initialise_taskserver() {
	output=$(taskd init)
	echo $output
}

# TODO: remove duplicate
make_pki_dir_in_taskddata() {
	TASKDDATA=$1
	output=$(mkdir -p $TASKDDATA/pki)
	echo $output
}

copy_pki_content_to_taskddata_dir() {
	TASKDDATA=$1
	TASKSERVER_TAR_NAME=$2
	output=$(cp -r $TASKSERVER_TAR_NAME/pki* $TASKDDATA)
	echo $output
}

# changes the local host in the vars file
set_local_host_in_vars_file_of_sourcedir() {
	IP=$1
	PORT=$2
	TASKSERVER_TAR_NAME=$3
	output=$(sed -i "s|CN=localhost|CN=$IP:$PORT|g" $TASKSERVER_TAR_NAME/pki/vars)
	echo $output
	# TODO: write unit test to verify the localhost is changed correctly
}

generate_certificates_in_pki_of_sourcedir() {
	TASKSERVER_TAR_NAME=$1
	output=$(cd $TASKSERVER_TAR_NAME/pki && ./generate)
	echo $output
}

copy_generated_client_cert_from_pki_in_sourcedir_to_taskddata() {
	TASKDDATA=$1
	TASKSERVER_TAR_NAME=$2
	output=$(cp $TASKSERVER_TAR_NAME/pki/client.cert.pem $TASKDDATA)
	echo $output
}

copy_generated_client_key_from_pki_in_sourcedir_to_taskddata() {
	TASKDDATA=$1
	TASKSERVER_TAR_NAME=$2
	output=$(cp $TASKSERVER_TAR_NAME/pki/client.key.pem $TASKDDATA)
	echo $output
}

copy_generated_server_cert_from_pki_in_sourcedir_to_taskddata() {
	TASKDDATA=$1
	TASKSERVER_TAR_NAME=$2
	output=$(cp $TASKSERVER_TAR_NAME/pki/server.cert.pem $TASKDDATA)
	echo $output
}

copy_generated_server_key_from_pki_in_sourcedir_to_taskddata() {
	TASKDDATA=$1
	TASKSERVER_TAR_NAME=$2
	output=$(cp $TASKSERVER_TAR_NAME/pki/server.key.pem $TASKDDATA)
	echo $output
}

copy_generated_server_crl_from_pki_in_sourcedir_to_taskddata() {
	TASKDDATA=$1
	TASKSERVER_TAR_NAME=$2
	output=$(cp $TASKSERVER_TAR_NAME/pki/server.crl.pem $TASKDDATA)
	echo $output
}

copy_generated_ca_cert_from_pki_in_sourcedir_to_taskddata() {
	TASKDDATA=$1
	TASKSERVER_TAR_NAME=$2
	output=$(cp $TASKSERVER_TAR_NAME/pki/ca.cert.pem $TASKDDATA)
	echo $output
}

configure_taskd_for_client_cert() {
	TASKDDATA=$1
	output=$(taskd config --force client.cert $TASKDDATA/client.cert.pem --data $TASKDDATA)
	echo $output
}

configure_taskd_for_client_key() {
	TASKDDATA=$1
	output=$(taskd config --force client.key $TASKDDATA/client.key.pem --data $TASKDDATA)
	echo $output
}

configure_taskd_for_server_cert() {
	TASKDDATA=$1
	output=$(taskd config --force server.cert $TASKDDATA/server.cert.pem --data $TASKDDATA)
	echo $output
}

configure_taskd_for_server_key() {
	TASKDDATA=$1
	output=$(taskd config --force server.key $TASKDDATA/server.key.pem --data $TASKDDATA)
	echo $output
}

configure_taskd_for_server_crl() {
	TASKDDATA=$1
	output=$(taskd config --force server.crl $TASKDDATA/server.crl.pem --data $TASKDDATA)
	echo $output
}

configure_taskd_for_ca_cert() {
	TASKDDATA=$1
	output=$(taskd config --force ca.cert $TASKDDATA/ca.cert.pem --data $TASKDDATA)
	echo $output
}

configure_taskserver_log() {
	TASKDDATA=$1
	PWD=$2
	output=$(taskd config --force log $PWD/taskd.log)
	echo $output
}

configure_taskserver_pid() {
	TASKDDATA=$1
	PWD=$2
	output=$(taskd config --force pid.file $PWD/taskd.pid)
	echo $output
}

configure_taskserver_ip_and_port() {
	IP=$1
	PORT=$2
	output=$(taskd config --force server $IP:$PORT)
	echo $output
}

show_taskd_config() {
	output=$(taskd config)
	echo $output
}


start_taskdctl() {
	output=$(taskdctl start)
	echo $output
}

show_running_taskdctl() {
	output=$(ps -leaf | grep taskd)
	echo $output
}

function swapline_containing_string {
  local OLD_LINE_PATTERN=$1; shift
  local NEW_LINE=$1; shift
  local FILE=$1
  local NEW=$(echo "${NEW_LINE}" | sed 's/\//\\\//g')
  touch "${FILE}"
  sed -i '/'"${OLD_LINE_PATTERN}"'/{s/.*/'"${NEW}"'/;h};${x;/./{x;q100};x}' "${FILE}"
  if [[ $? -ne 100 ]] && [[ ${NEW_LINE} != '' ]]
  then
    echo "${NEW_LINE}" >> "${FILE}"
  fi
}

modify_taskd_service_file(){
	taskddata=$1
	echo "taskddata=$taskddata" >&2
	
	linux_username=$(whoami)
	echo "linux_username=$linux_username" >&2
	linux_group=$linux_username
	echo "linux_group=$linux_group" >&2
	
	swapline_containing_string "ExecStart=" "ExecStart=/usr/local/bin/taskd server --data $taskddata" "src/taskd.service"
	swapline_containing_string "User=" "User=$linux_username" "src/taskd.service"
	swapline_containing_string "Group=" "Group=$linux_group" "src/taskd.service"
	swapline_containing_string "WorkingDirectory=" "WorkingDirectory=$taskddata" "src/taskd.service"
	echo $output
	# TODO: unit test
	# TODO: move swapline function to helper.sh
}

copy_taskd_service_file() {
	#output=$(cp src/taskd.service /etc/systemd/system)
	# fails, no permission
	output=$(sudo cp src/taskd.service /etc/systemd/system)
	echo "output=$output" >&2
}

reload_deamon() {
	output=$(sudo systemctl daemon-reload)
	# TODO: this should be run as root, verify if sudo is root.
	echo "output=$output" >&2
}

start_taskd_server() {
	output=$(sudo systemctl start taskd.service)
	# TODO: this should be run as root, verify if sudo is root.
	echo "output=$output" >&2
}

check_status_taskd_server() {
	output=$(systemctl status taskd.service)
	# TODO: this should be run as root, verify if sudo is root.
	echo "output=$output" >&2
}

enable_starting_taskd_server_at_boot() {
	output=$(sudo systemctl enable taskd.service)
	# TODO: this should be run as root, verify if sudo is root.
	echo "output=$output" >&2
}

add_organisation_to_taskserver() {
	TASKDDATA=$1
	TW_ORGANISATION=$2
	output=$(taskd add org $TW_ORGANISATION --data $TASKDDATA)
	echo $output
}

add_user_to_taskserver() {
	TASKDDATA=$1
	TW_ORGANISATION=$2
	TW_USERNAME=$3
	output=$(taskd add user $TW_ORGANISATION $TW_USERNAME --data $TASKDDATA)
	echo $output
}

generate_user_certificate() {
	TASKSERVER_TAR_NAME=$1
	TW_USERNAME=$2
	output=$(cd $TASKSERVER_TAR_NAME/pki && ./generate.client $TW_USERNAME)
	echo $output
	# TODO: make username First into a variable
}

copy_user_certificate_to_dot_task_dir() {
	LINUX_USERNAME=$1
	TASKSERVER_TAR_NAME=$2
	output=$(cp $TASKSERVER_TAR_NAME/pki/$TW_USERNAME.cert.pem /home/$LINUX_USERNAME/.task)
	echo $output
	# TODO: change the ~ to some variable of the user path
}

copy_user_certificate_key_to_dot_task_dir() {
	LINUX_USERNAME=$1
	TASKSERVER_TAR_NAME=$2
	output=$(cp $TASKSERVER_TAR_NAME/pki/$TW_USERNAME.key.pem /home/$LINUX_USERNAME/.task)
	echo $output
	# TODO: change the ~ to some variable of the user path
}

copy_ca_cert_to_dot_task_dir() {
	LINUX_USERNAME=$1
	TASKSERVER_TAR_NAME=$2
	output=$(cp $TASKSERVER_TAR_NAME/pki/ca.cert.pem /home/$LINUX_USERNAME/.task)
	echo $output
	# TODO: change the ~ to some variable of the user path
}

configure_taskserver_config_user_certificate() {
	LINUX_USERNAME=$1
	TW_USERNAME=$2
	output=$(yes | task config taskd.certificate -- /home/$LINUX_USERNAME/.task/$TW_USERNAME.cert.pem)
	echo $output
	# TODO: change the ~ to some variable of the user path
}

# 20 
configure_taskserver_config_user_key() {
	LINUX_USERNAME=$1
	TW_USERNAME=$2
	output=$(yes | task config taskd.key -- /home/$LINUX_USERNAME/.task/$TW_USERNAME.key.pem)
	echo $output
	# TODO: change the ~ to some variable of the user path
}

configure_taskserver_config_ca_cert() {
	output=$(yes | task config taskd.ca -- /home/$LINUX_USERNAME/.task/ca.cert.pem)
	echo $output
	# TODO: change the ~ to some variable of the user path
}

configure_taskserver_config_ip_and_port() {
	IP=$1
	PORT=$2
	#output=$(yes | sudo task config taskd.server -- 0.0.0.0:53589)
	output=$(yes | task config taskd.server -- $IP:$PORT)
	echo $output
	# TODO: make server and port into variable
}

# 21
set_taskserver_credentials() {
	TW_ORGANISATION=$1
	TW_USERNAME=$2
	KEY=$3
	echo "in function KEY=$KEY"
	output=$(yes | task config taskd.credentials -- $TW_ORGANISATION/$TW_USERNAME/$KEY)
	echo $output
}

first_taskserver_sync_init() {
	output=$(yes | task sync init)
	echo $output
}
