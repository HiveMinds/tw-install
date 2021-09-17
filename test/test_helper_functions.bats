#!./test/libs/bats/bin/bats

load 'libs/bats-support/load'
load 'libs/bats-assert/load'
load 'libs/bats-file/load'

source src/helper.sh

setup() {
	# print test filename to screen.
	if [ "${BATS_TEST_NUMBER}" = 1 ];then
		echo "# Testfile: $(basename ${BATS_TEST_FILENAME})-" >&3
	fi
}

@test "Test if either the home/$USER/anaconda3 or .../anaconda directory exists." {
	# TODO assert file does not exists
	#assert_file_exist /home/some_path

	# create log directory
	mkdir -p src/logs
	
	# create log file
	echo "helloworld" > src/logs/test_log_file.txt

	TEST_RESULT=$(remove_logs)
	
	# TODO: write test that verifies the folder is empty, not just that the test_log_file.txt is removed.
	
	# test if the log directory is removed.
	if [ -f "src/logs/test_log_file.txt" ]; then
		assert_equal true false
	else
		assert_equal true true
	fi
}