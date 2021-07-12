#!./test/libs/bats/bin/bats

load 'libs/bats-support/load'
load 'libs/bats-assert/load'

@test "running the file in /src/main.sh." {
	run sh src/main.sh
    assert_output "Hello world"
}