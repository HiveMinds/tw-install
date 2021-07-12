#!./test/libs/bats/bin/bats

load 'libs/bats-support/load'
load 'libs/bats-assert/load'


@test "running the file in /src/two_functions.sh." {
    source ./src/examples/two_functions.sh
    output=$(some_active_function 9 -51)
    ((output == -42))
}