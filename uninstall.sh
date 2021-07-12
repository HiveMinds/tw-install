# read hardcoded variables
SOURCEDIR=$PWD
source src/hardcoded_variables.txt

# get installation dependent parameters
LINUX_USERNAME=$(whoami)
LINUX_GROUP=$(whoami)
echo $LINUX_USERNAME
IP=$(hostname -f)
echo $IP

#git clone --recursive https://github.com/GothenburgBitFactory/taskserver.git
#cd $SOURCEDIR/taskserver/ && echo | sudo checkinstall  -D -y
#cd $SOURCEDIR/taskserver/ && sudo dpkg -r taskd
#cd $SOURCEDIR/taskserver/ && sudo dpkg -r taskserver
#cd ..

yes | sudo apt remove taskwarrior


#folder
sudo rm -r taskserver

sudo rm -r /var/taskd
sudo rm -r /home/$LINUX_USERNAME/.task
sudo rm -r /home/$LINUX_USERNAME/taskd # can be ommited
sudo rm /var/taskd.log
sudo rm /var/taskd.pid
sudo rm /var/userkey.txt
sudo rm /usr/local/bin/taskd
sudo rm /usr/local/bin/taskdctl

sudo rm /home/$LINUX_USERNAME/.task
sudo rm /home/$LINUX_USERNAME/.taskrc
sudo rm /usr/local/bin/taskd
sudo rm /usr/local/bin/taskdctl

#folder
sudo rm -r /usr/local/share/doc/taskd
#folder
sudo rm -r /usr/local/share/man/man1/taskd.1
sudo rm -r /usr/local/share/man/man1/taskdctl.1
#folder
sudo rm -r /usr/local/share/man/man5/taskdrc.5
#folder
sudo rm -r /usr/local/share/doc/taskd
#folder
sudo rm -r /usr/local/share/taskd
# Below file not found after a fresh installation:
sudo rm /usr/local/share/fonts/.uuid

#folder
sudo rm -r /usr/share/doc/taskwarrior/

sudo rm /usr/share/man/man1/task.1.gz

sudo rm /usr/share/man/man5/task-color.5.gz
sudo rm /usr/share/man/man5/taskrc.5.gz
sudo rm /usr/share/man/man5/task-sync.5.gz

sudo rm /var/lib/dpkg/info/taskwarrior.list
sudo rm /var/lib/dpkg/info/taskwarrior.md5sums
sudo rm /var/lib/dpkg/info/taskwarrior.postinst
sudo rm /var/lib/dpkg/info/taskwarrior.postrm
sudo rm /var/lib/dpkg/info/taskwarrior.preinst
sudo rm /var/lib/dpkg/info/taskwarrior.prerm

sudo rm /var/taskd.log
sudo rm /var/taskd.pid
#folder
sudo rm -r /var/taskd
sudo rm /var/userkey.txt
