#!/bin/sh
write_to_log() {

  # read incoming arguments
  _local dest_dir="$1"
  _local dest_file="$2"
  _local dest_path="$dest_dir$dest_file"

  shift # eat first argument
  shift # eat second argument

  # create empty file (overwrite previous content if it exists)
  : >"$dest_path"

  # append remaining args to file
  for i in '$*'; do
    cat <<<"$i" >>"$dest_path"
  done
}

remove_logs() {
  rm -r src/logs/*
}

read_user_key_from_log() {
  _local value="$(<src/logs/D_26_add_user_to_taskserver.txt)"
  _local result=${value:14:36}
  echo "$result"
}
