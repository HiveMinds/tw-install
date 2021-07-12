# Taskwarrior Installer [![Build Status](https://travis-ci.org/a-t-0/Taskwarrior-installation.svg?branch=refactor_to_shell)](https://travis-ci.org/a-t-0/Taskwarrior-installation)
This installs taskwarrior and taskwarrior server for you on an Ubuntu device with 2 simple commands. In my experience Taskwarrior (and Timewarrior) are increadibly powerfull tools to monitor and improve your effectiveness in many aspects of life, yet I found setting it up [a bit challenging](https://www.youtube.com/watch?v=nuE4v5xKIWc), so I automated the procedure. I invite you to have a look at [how to expand this toolkit](https://github.com/HiveMinds-EU/Taskwarrior-installation/issues?q=is%3Aopen+is%3Aissue+label%3Aenhancement)!

## How to use (for users)
Run the main code from the root of this repository with:
```
git clone git@github.com:HiveMinds-EU/Taskwarrior-installation.git
cd Taskwarrior-installation
chmod +x main.sh
./main.sh
```
Uninstall it with:
```
chmod +x uninstall.sh
./uninstall.sh
```
That's it, you can now add tasks with: `task add make pancakes` and sync it with your own taskwarrior server with: `task sync` :)

## How to use (for developers)
First install the required submodules with:
```
git clone git@github.com:HiveMinds-EU/Taskwarrior-installation.git
cd Taskwarrior-installation
chmod +x install-bats-libs.sh
./install-bats-libs.sh
```

Next, run the unit tests with:
```
chmod +x test.sh
./test.sh
```
Note: Put your unit test files (with extention .bats) in folder: `/test/`
