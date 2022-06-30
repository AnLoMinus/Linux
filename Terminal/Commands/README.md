# Commands

- There are hundreds – possibly thousands –  commands available in Linux. <br>
- Remembering every command is not possible and it can be quite daunting for a novice user. <br>
- The good news is that you don't need to remember each command. <br>
- Only a very small subset of those commands are used on a day-to-day basis.<br><br>
- This cheat sheet offers a set of commands that you can use for quick reference. <br>
- I have prepared this Linux Commands Cheat Sheet as quick reference for both experienced and basic users.


---

# Content

- [Basic Linux Commands](#basic-linux-commands)
- [Networking Commands](#networking-commands)
- [File Permission Commands](#file-permission-commands)
- [User and Group Management Commands](#user-and-group-management-commands)
- [Process Management Commands](#Process-Management-Commands)
- [Disk Management Commands](#Disk-Management-Commands)
- [Package Management Command](#Package-Management-Command)
- [Compress and Uncompress Commands](#Compress-and-Uncompress-Commands)

---

Basic Linux Commands
--------------------

In this section, we will show you some basic Linux commands with examples.

Command

Description

`hostnamectl`

Get system information including, operating system, kernel, and release version

`date`

Display the current system date and time

`hostname`

Display the hostname of the system

`ifconfig`

Display the IP and Mac Address of the system

`w`

Display currently logged in users in the system

`free -m`

Display free and used memory in the system

`top`

Display all running processes

`ls`

List all files and directories in the current working directory

`ls -al`

List all files and directories including, hidden files and other information like permissions, size, and owner

`cd`

Change the directory to the home directory

`cd ..`

Change the directory to one level up

`cat filename`

Display the content of the file

`cat file1 file2 > file3`

Combine two files named file1 and file2 and store the output in a new file file3

`tail filename`

Display the last 10 lines of a file

`head filename`

Display the first 10 lines of a file

`mv oldfile newfile`

Rename a file

`rm filename`

Delete a file

`mkdir dirname`

Create a directory

`rm -rf dirname`

Remove a directory

`history`

Print a history list of all commands

`clear`

Clear the terminal

`shutdown -h now`

Shut down the system

`reboot`

Restart the system

---

Networking Commands
-------------------

Command

Description

`ip addr show` Or `ifconfig`

List all IP addresses and network interfaces

`ip addr add IP-Address dev eth1`

Add a temporary IP address to interface eth1

`netstat -pnltu`

Display all listening port

`whois domainname`

Display more information about any domain

`dig domainname`

Display DNS information of any domain

`host domainname`

Perform an IP lookup for a domain

`dig -x IP-Address`

Perform a reverse lookup of an IP address

`dig -x domainame`

Perform a reverse lookup on domain

`ping host-ip`

Check connectivity between two hosts

---

File Permission Commands
------------------------

Command

Description

`ls -l filename`

Check the current permission of any file

`chmod 777 filename`

Assign full(read, write, and execute) permission to everyone

`chmod -R 777 dirname`

Assign full permission to the directory and all sub-directories

`chmod 766 filename`

Assign full permission to the owner, and read and write permission to group and others

`chmod -x filename`

Remove the execution permission of any file

`chown username filename`

Change the ownership of a file

`chown user:group filename`

Change the owner and group ownership of a file

`chown -R user:group dirname`

Change the owner and group ownership of the directory and all sub-directories

---

User and Group Management Commands
----------------------------------

Linux is a multi-user operating system. So multiple users can log in to the system and work on the system at the same time. In some cases, two or more users may need to share access to system resources like files and directories. In that case, user and group management allows you to complete your objectives.

Command

Description

`w`

Display all login users

`useradd username`

Add a new user account

`userdel -r username`

Delete a user account

`usermod [option] username`

Change the user account information including, group, home directory, shell, expiration date

`usermod -aG groupname username`

Add a user to a specific group

`groupadd groupname`

Create a new group

`groupdel groupname`

Remove a group

`last`

Display information of the last login user

`id`

Display UID and GID of the current user

---

Process Management Commands
---------------------------

When you run any application in Linux. The application will get a process ID or PID. Process Management helps you to monitor and manage your application.

Command

Description

`ps`

Display all active processes

`ps -ef | grep processname`

Display information of specific process

`top`

Manage and display all processes in realtime

`pstree`

Display processes in the tree-like diagram

`lsof`

List all files opened by running processes

`kill pid`

Kill a specific process using process ID

`killall processname`

Kill all processes by name

`bg`

Display stopped or background jobs

`pidof processname`

Get the PID of any process

---

Disk Management Commands
------------------------

In this section, we will show you disk management commands including, add and remove partitions, mount a partition, check disk space, format partition, etc.

Command

Description

`fdisk -l`

List all disk partitions

`fdisk /dev/sda`

Create a new partition on /dev/sda device

`mkfs.ext4 /dev/sda1`

Format the partition named /dev/sda1

`fsck.ext4 /dev/sda1`

Check and repair a filesystem for any error

`mount /dev/sda1 /mnt`

Mount any partition to any directory

`df -h`

Display free space of mounted file system

`df -i`

Display free inodes on the filesystem

`du -hs`

Display the size of your current directory

`lsblk`

Display information about block devices

`lsusb -tv`

Display all USB devices

`hdparm -tT /dev/sda`

Perform a read speed test on disk /dev/sda

`badblocks -s /dev/sda`

Test for unreadable blocks on disk /dev/sda

---

Package Management Command
--------------------------

In this section, we will show a list of all commands to install, remove and manage packages in Linux.

Command

Description

`apt-get install packagename`

Install the package on Debian based distributions

`apt-get remove packagename`

Remove a package on Debian based distributions

`dpkg -l | grep -i installed`

Get a list of all packages on Debian based distributions

`dpkg -i packagename.deb`

Install .deb package

`apt-get update`

Update the repository on Debian based distributions

`apt-get upgrade packagename`

Upgrade a specific package on Debian based distributions

`apt-get autoremove`

Remove all unwanted packages on Debian based distributions

`yum install packagename`

Install the package on RPM-based distributions

`yum remove packagename`

Remove a package on RPM-based distributions

`yum update`

Update all system packages to the latest version on RPM-based distributions

`yum list --installed`

List all installed packages on RPM-based distributions

`yum list --available`

List all available packages on RPM-based distributions

---

Compress and Uncompress Commands
--------------------------------

Tar, Zip, and Unzip are the most popular command-line utility in Linux used to compress and uncompress files and directories.

Command

Description

`tar -cvf filename.tar filename`

Compress a file in the Tar archive

`tar -xvf filename.tar`

Uncompress a Tar file

`tar -tvf filename.tar`

List the content of the Tar file

`tar -xvf filename.tar file1.txt`

Untar a single file from Tar file

`tar -rvf filename.tar file2.txt`

Add a file to the Tar file

`zip filename.zip filename`

Compress a single file to a zip

`zip filename.zip file1.txt file2.txt file3.txt`

Compress multiple files to a zip

`zip -u filename.zip file4.txt`

Add a file to a zip file

`zip -d filename.zip file4.txt`

Delete a file from a zip file

`unzip -l filename.zip`

Display the content of zip archive file

`unzip filename.zip`

Unzip a file

`unzip filename.zip -d /dirname`

Unzip a file to a specific directory
