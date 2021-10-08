# Taskwarrior Installer [![Build Status](https://travis-ci.org/HiveMinds-EU/tw-install.svg?branch=refactor_to_shell)](https://travis-ci.org/HiveMinds-EU/tw-install)
This installs taskwarrior and taskwarrior server for you on an Ubuntu device (or on Windows with the WSL app, I did not try Mac yet.) with 2 simple commands. In my experience Taskwarrior (and Timewarrior) are increadibly powerfull tools to monitor and improve your effectiveness in many aspects of life, yet I found setting it up [a bit challenging](https://www.youtube.com/watch?v=nuE4v5xKIWc), so I automated the procedure. I invite you to have a look at [how to expand this toolkit](https://github.com/HiveMinds-EU/tw-install/milestones)! Feel free to pick up an issue (claim it in the comments to prevent double work), fork the repository, and send a pull request with your solution :)

## How to use (for users)
Run the Taskwarrior installer from the root of this repository with:
```
cd ~/.task
git clone git@github.com:HiveMinds-EU/tw-install.git install
cd install
chmod +x tw-install.sh
./tw-install.sh
```
That's it, you can now add tasks with: `task add make pancakes` and sync it with your own taskwarrior server with: `task sync` :)


Uninstall taskwarrior and taskserver it with:
```
chmod +x tw-uninstall.sh
./tw-uninstall.sh
```
(Currently) you have to reboot the system before you install it again using the `tw-install.sh` file.

## How to use (for developers)
First install the required submodules with:
```
cd ~/.task
git clone git@github.com:HiveMinds-EU/tw-install.git install
cd install
rm -r test/libs/*
chmod +x install-bats-libs.sh
./install-bats-libs.sh
```

Next, run the unit tests with:
```
chmod +x test.sh
./test.sh
```
Note: Put your unit test files (with extention .bats) in folder: `/test/`
