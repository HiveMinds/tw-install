#!/bin/bash
run_at_boot_command="export TASKDDATA=$TASKDDATA && taskdctl start"
# Check if the cron job already exists
if crontab -l | grep -q "$run_at_boot_command"; then
  echo "Cron job already exists. Skipping setup."
else
  # Add the cron job entry to run every day at 02:01 midnight.
  (
    crontab -l 2>/dev/null
    echo "@reboot $run_at_boot_command"
  ) | crontab -
  echo "Cron job successfully set up."
fi

# Assert the cronjob was added successfully.
if crontab -l | grep -q "$backup_manager_command"; then
  echo ""
else
  echo "Error, cronjob was not found."
  exit 5
fi