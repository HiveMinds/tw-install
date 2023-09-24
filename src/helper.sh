#!/bin/bash
write_to_log() {

  # read incoming arguments
  local dest_dir="$1"
  local dest_file="$2"
  local dest_path="$dest_dir$dest_file"

  shift # eat first argument
  shift # eat second argument

  # create empty file (overwrite previous content if it exists)
  : >"$dest_path"

  # append remaining args to file
  for i in '$*'; do
    cat echo "$i" >>"$dest_path"
  done
}

remove_logs() {
	{ # try
		$rm -r src/logs/*
		#save your output
		true
	} || { # catch
		# save log for exception 
		true
	}
}

read_user_key_from_log() {
  local value="$(<src/logs/D_26_add_user_to_taskserver.txt)"
  local result=${value:14:36}
  echo "$result"
}
