#!./test/libs/bats/bin/bats

load 'libs/bats-support/load'
load 'libs/bats-assert/load'

@test "running the file in /src/active_function_string_manipulation.sh." {
	input="This Is a TEST"
	run ./src/examples/active_function_string_manipulation.sh "This Is a TEST"
    assert_output "this is a test"
}