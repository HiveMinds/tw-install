mkdir -p test/libs

git submodule add --force https://github.com/sstephenson/bats test/libs/bats
git submodule add --force https://github.com/ztombol/bats-support test/libs/bats-support
git submodule add --force https://github.com/ztombol/bats-assert test/libs/bats-assert
git submodule add --force https://github.com/ztombol/bats-file test/libs/bats-file
