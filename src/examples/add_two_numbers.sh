#!/usr/bin/env bash
add_two_numbers()
{
x=$1
y=$2
echo -e "Numbers entered by you are: $x and $y"
echo "Sum of $x and $y is: $(expr $x + $y)"
}

add_two_numbers "$@" "$@"