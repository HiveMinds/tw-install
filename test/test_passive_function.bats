#!./test/libs/bats/bin/bats

load 'libs/bats-support/load'
load 'libs/bats-assert/load'

@test "running the file in /src/passive_function.sh." {
	run sh src/examples/passive_function.sh
    assert_output "hello world"
}