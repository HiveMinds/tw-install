#!./test/libs/bats/bin/bats

load 'libs/bats-support/load'
load 'libs/bats-assert/load'

@test "running the file in /src/active_function_addition.sh." {
	run ./src/examples/active_function_addition.sh 9 33
    assert_output 42
}