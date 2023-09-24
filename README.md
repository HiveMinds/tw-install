# Taskwarrior Installer 

[![Build Status](https://raw.githubusercontent.com/a-t-0/gitlab-ci-build-statuses/master/hiveminds/tw-install/develop/build_status.svg)](http://2gzyxa5ihm7nsggfxnu52rck2vv4rvmdlkiu3zzui5du4xyclen53wid.onion/)

This installs taskwarrior and taskwarrior server for you on an Ubuntu device (or on Windows with the WSL app, I did not try Mac yet.) with 2 simple commands. In my experience Taskwarrior (and Timewarrior) are increadibly powerfull tools to monitor and improve your effectiveness in many aspects of life, yet I found setting it up [a bit challenging](https://www.youtube.com/watch?v=nuE4v5xKIWc), so I automated the procedure. 

## How to help
- Contribute to the self-hosted GitLab CI on it over [here](https://github.com/TruCol/Self-host-GitLab-CI-for-GitHub) which I would like to run on this repo.
- After CI works, I would like to refactor this repo using [this template](https://github.com/HiveMinds/Bash-Project-Template).

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

## Docker (not working)
A short headsup, the `docker build .` is currently not working as kindly pointed out [here](https://github.com/HiveMinds/tw-install/issues/102)

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
