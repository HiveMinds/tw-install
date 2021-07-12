# Developer Notes

0. To safely test your installation modifications on your main pc with used taskwarrior and timewarrior data, you can use the following commands in WSL Ubuntu 18.04 to make a quick backup of your taskwarrior data to folder: `c:/Taskwarrior/2020-08-05_taskwarrior_backup/` (or whatever the date is when you use this)
1. First make the backup target location
```
cd /mnt/c/
mkdir Taskwarrior
cd Taskwarrior
mkdir "$(date +"%d-%m-%Y")_taskwarrior_backup"
```
2. Then copy the taskwarrior files to the backup target destination.
```
cp ~/.task/backlog.data "/mnt/c/Taskwarrior/$(date +"%d-%m-%Y")_taskwarrior_backup"
cp ~/.task/undo.data "/mnt/c/Taskwarrior/$(date +"%d-%m-%Y")_taskwarrior_backup"
cp ~/.task/pending.data "/mnt/c/Taskwarrior/$(date +"%d-%m-%Y")_taskwarrior_backup"
cp ~/.task/completed.data "/mnt/c/Taskwarrior/$(date +"%d-%m-%Y")_taskwarrior_backup"
```
3. VERIFY THE FILES ARE CREATED AT THE TARGET DESTINATION TIME YOU COPIED THEM!
4. Next you can copy the timewarrior files to the backup folder at:`c:/Taskwarrior/2020-08-05_timewarrior_backup/`
```
cd /mnt/c/
mkdir Timewarrior
cd Timewarrior
mkdir "$(date +"%d-%m-%Y")_timewarrior_backup"
```
5. Copy the timewarrior files:
```
cp ~/.timewarrior/backlog.data "/mnt/c/Timewarrior/$(date +"%d-%m-%Y")_timewarrior_backup"
cp ~/.timewarrior/undo.data "/mnt/c/Timewarrior/$(date +"%d-%m-%Y")_timewarrior_backup"
cp ~/.timewarrior/pending.data "/mnt/c/Timewarrior/$(date +"%d-%m-%Y")_timewarrior_backup"
cp ~/.timewarrior/completed.data "/mnt/c/Timewarrior/$(date +"%d-%m-%Y")_timewarrior_backup"
```
6. TLDR 
```
```