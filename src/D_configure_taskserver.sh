#!/bin/sh
mkdir_taskd_data() {
	TASKDDATA="$1"
	_local output="$(mkdir -p "$TASKDDATA")"
	echo "$output"
	# TODO: test whether the folder did not already exist
}


mkdir_taskd_data_pki() {
	TASKDDATA="$1"
	_local output="$(mkdir -p "$TASKDDATA"/pki)"
	echo "$output"
	# TODO: test whether the folder did not already exist
}


initialise_task_server() {
	_local output="$(taskd init)"
	echo "$output"
}

# TODO: remove duplicate
make_pki_dir_in_taskd_data() {
	TASKDDATA="$1"
	_local output="$(mkdir -p "$TASKDDATA"/pki)"
	echo "$output"
}

copy_pki_content_to_taskd_data_dir() {
	TASKDDATA="$1"
	_local task_server_tar_name="$2"
	_local output="$(cp -r "$task_server_tar_name"/pki* "$TASKDDATA")"
	echo "$output"
}

# changes the local host in the vars file
set_local_host_in_vars_file_of_source_dir() {
	_local ip="$1"
	_local port="$2"
	_local task_server_tar_name="$3"
	_local output="$(sed -i "s|CN=localhost|CN=$ip:$port|g" "$task_server_tar_name"/pki/vars)"
	echo "$output"
	# TODO: write unit test to verify the localhost is changed correctly
}

generate_certificates_in_pki_of_source_dir() {
	_local task_server_tar_name="$1"
	_local output="$(cd "$task_server_tar_name"/pki && ./generate)"
	echo "$output"
}

copy_generated_client_cert_from_pki_in_source_dir_to_taskd_data() {
	TASKDDATA="$1"
	_local task_server_tar_name="$2"
	_local output="$(cp "$task_server_tar_name"/pki/client.cert.pem "$TASKDDATA")"
	echo "$output"
}

copy_generated_client_key_from_pki_in_source_dir_to_taskd_data() {
	TASKDDATA="$1"
	_local task_server_tar_name="$2"
	_local output="$(cp "$task_server_tar_name"/pki/client.key.pem "$TASKDDATA")"
	echo "$output"
}

copy_generated_server_cert_from_pki_in_source_dir_to_taskd_data() {
	TASKDDATA="$1"
	_local task_server_tar_name="$2"
	_local output="$(cp "task_server_tar_name"/pki/server.cert.pem "$TASKDDATA")"
	echo "$output"
}

copy_generated_server_key_from_pki_in_source_dir_to_taskd_data() {
	TASKDDATA="$1"
	_local task_server_tar_name="$2"
	_local output="$(cp "$task_server_tar_name"/pki/server.key.pem "$TASKDDATA")"
	echo "$output"
}

copy_generated_server_crl_from_pki_in_source_dir_to_taskd_data() {
	TASKDDATA="$1"
	_local task_server_tar_name="$2"
	_local output="$(cp "$task_server_tar_name"/pki/server.crl.pem "$TASKDDATA")"
	echo "$output"
}

copy_generated_ca_cert_from_pki_in_source_dir_to_taskd_data() {
	TASKDDATA="$1"
	_local task_server_tar_name="$2"
	_local output="$(cp "$task_server_tar_name"/pki/ca.cert.pem "$TASKDDATA")"
	echo "$output"
}

configure_taskd_for_client_cert() {
	TASKDDATA="$1"
	_local output="$(taskd config --force client.cert "$TASKDDATA"/client.cert.pem --data "$TASKDDATA")"
	echo "$output"
}

configure_taskd_for_client_key() {
	TASKDDATA="$1"
	_local output="$(taskd config --force client.key "$TASKDDATA"/client.key.pem --data "$TASKDDATA")"
	echo "$output"
}

configure_taskd_for_server_cert() {
	TASKDDATA="$1"
	_local output="$(taskd config --force server.cert "$TASKDDATA"/server.cert.pem --data "$TASKDDATA")"
	echo "$output"
}

configure_taskd_for_server_key() {
	TASKDDATA="$1"
	_local output="$(taskd config --force server.key "$TASKDDATA"/server.key.pem --data "$TASKDDATA")"
	echo "$output"
}

configure_taskd_for_server_crl() {
	TASKDDATA="$1"
	_local output="$(taskd config --force server.crl "$TASKDDATA"/server.crl.pem --data "$TASKDDATA")"
	echo "$output"
}

configure_taskd_for_ca_cert() {
	TASKDDATA="$1"
	_local output="$(taskd config --force ca.cert "$TASKDDATA"/ca.cert.pem --data "$TASKDDATA")"
	echo "$output"
}

configure_task_server_log() {
	TASKDDATA="$1"
	_local pwd="$2"
	_local output="$(taskd config --force log "$pwd"/taskd.log)"
	echo "$output"
}

configure_task_server_pid() {
	TASKDDATA="$1"
	_local pwd="$2"
	_local output="$(taskd config --force pid.file "$pwd"/taskd.pid)"
	echo "$output"
}

configure_task_server_ip_and_port() {
	_local ip="$1"
	_local port="$2"
	_local output="$(taskd config --force server "$ip":"$port")"
	echo "$output"
}

show_taskd_config() {
	_local output="$(taskd config)"
	echo "$output"
}


start_taskdctl() {
	_local output="$(taskdctl start)"
	echo "$output"
}

show_running_taskdctl() {
	_local output="$(ps -leaf | pgrep taskd)"
	echo "$output"
}

swapline_containing_string() {
  _local old_line_pattern="$1"; shift
  _local new_line="$1"; shift
  _local file="$1"
  _local new="$(echo "${new_line}" | sed 's/\//\\\//g')"
  touch "${file}"
  sed -i '/'"${old_line_pattern}"'/{s/.*/'"${new}"'/;h};${x;/./{x;q100};x}' "${file}"
  if [ $? -ne 100 ] && [ "${new_line}" != '' ]
  then
    echo "${new_line}" >> "${file}"
  fi
}

modify_taskd_service_file(){
	taskd_data="$1"
	echo "taskd_data=$taskd_data" >&2
	
	linux_username=$(whoami)
	echo "linux_username=$linux_username" >&2
	linux_group=$linux_username
	echo "linux_group=$linux_group" >&2
	
	swapline_containing_string "ExecStart=" "ExecStart=/usr/local/bin/taskd server --data $taskd_data" "src/taskd.service"
	swapline_containing_string "User=" "User=$linux_username" "src/taskd.service"
	swapline_containing_string "Group=" "Group=$linux_group" "src/taskd.service"
	swapline_containing_string "WorkingDirectory=" "WorkingDirectory=$taskd_data" "src/taskd.service"
	echo "$output"
	# TODO: unit test
	# TODO: move swapline function to helper.sh
}

copy_taskd_service_file() {
	#_local output=$(cp src/taskd.service /etc/systemd/system)
	# fails, no permission
	_local output="$(sudo cp src/taskd.service /etc/systemd/system)"
	echo "output=$output" >&2
}

reload_deamon() {
	_local output="$(sudo systemctl daemon-reload)"
	# TODO: this should be run as root, verify if sudo is root.
	echo "output=$output" >&2
}

start_taskd_server() {
	_local output="$(sudo systemctl start taskd.service)"
	# TODO: this should be run as root, verify if sudo is root.
	echo "output=$output" >&2
}

check_status_taskd_server() {
	_local output="$(systemctl status taskd.service)"
	# TODO: this should be run as root, verify if sudo is root.
	echo "output=$output" >&2
}

enable_starting_taskd_server_at_boot() {
	_local output="$(sudo systemctl enable taskd.service)"
	# TODO: this should be run as root, verify if sudo is root.
	echo "output=$output" >&2
}

add_organisation_to_task_server() {
	TASKDDATA="$1"
	_local tw_organisation="$2"
	_local output="$(taskd add org "$tw_organisation" --data "$TASKDDATA")"
	echo "$output"
}

add_user_to_task_server() {
	TASKDDATA="$1"
	_local tw_organisation="$2"
	_local tw_username="$3"
	_local output="$(taskd add user "$tw_organisation" "$tw_username" --data "$TASKDDATA")"
	echo "$output"
}

generate_user_certificate() {
	_local task_server_tar_name="$1"
	_local tw_username="$2"
	_local output="$(cd "$task_server_tar_name"/pki && ./generate.client "$tw_username")"
	echo "$output"
	# TODO: make username First into a variable
}

copy_user_certificate_to_dot_task_dir() {
	_local linux_username="$1"
	_local task_server_tar_name="$2"
	_local output="$(cp "$task_server_tar_name"/pki/"$tw_username".cert.pem /home/"$_local linux_username"/.task)"
	echo "$output"
	# TODO: change the ~ to some variable of the user path
}

copy_user_certificate_key_to_dot_task_dir() {
	_local linux_username="$1"
	_local task_server_tar_name="$2"
	_local output="$(cp "$task_server_tar_name"/pki/"$tw_username".key.pem /home/"$_local linux_username"/.task)"
	echo "$output"
	# TODO: change the ~ to some variable of the user path
}

copy_ca_cert_to_dot_task_dir() {
	_local linux_username="$1"
	_local task_server_tar_name="$2"
	_local output="$(cp "$task_server_tar_name"/pki/ca.cert.pem /home/"$_local linux_username"/.task)"
	echo "$output"
	# TODO: change the ~ to some variable of the user path
}

configure_task_server_config_user_certificate() {
	_local linux_username="$1"
	_local tw_username="$2"
	_local output="$(yes | task config taskd.certificate -- /home/"$_local linux_username"/.task/"$tw_username".cert.pem)"
	echo "$output"
	# TODO: change the ~ to some variable of the user path
}

# 20 
configure_task_server_config_user_key() {
	_local linux_username="$1"
	_local tw_username="$2"
	_local output="$(yes | task config taskd.key -- /home/"$_local linux_username"/.task/"$tw_username".key.pem)"
	echo "$output"
	# TODO: change the ~ to some variable of the user path
}

configure_task_server_config_ca_cert() {
	_local output="$(yes | task config taskd.ca -- /home/"$_local linux_username"/.task/ca.cert.pem)"
	echo "$output"
	# TODO: change the ~ to some variable of the user path
}

configure_task_server_config_ip_and_port() {
	_local ip="$1"
	_local port="$2"
	#_local output=$(yes | sudo task config taskd.server -- 0.0.0.0:53589)
	_local output="$(yes | task config taskd.server -- "$ip":"$port")"
	echo "$output"
	# TODO: make server and port into variable
}

# 21
set_task_server_credentials() {
	_local tw_organisation="$1"
	_local tw_username="$2"
	_local key="$3"
	echo "in function KEY=$key"
	_local output="$(yes | task config taskd.credentials -- "$tw_organisation"/"$tw_username"/"$key")"
	echo "$output"
}

first_task_server_sync_init() {
	_local output="$(yes | task sync init)"
	echo "$output"
}