#!/bin/bash

#Change passwords 
#add own superuser 
#remove the premade superuser from sudo 
#Change time  
#Disallow root logins over SSH

#check cron 
#https://unix.stackexchange.com/questions/347814/how-can-i-see-all-cron-records-in-centos7 

#Centos internal 
#disable ssh(6092), rpcbind (5564), smtp(5415), chronyd(5523)

#check last installed 
#$ rpm -qa --last | head 

#Preinstalled:
#sos-3.6-11.e17 / sos, sosreport 

#Must do me or else no updates will work lol 
sudo echo "http_caching=packages" >> vi /etc/yum.conf 

#hardening
#Increase the delay time between login prompts (10sec)
sed -i "s/delay=[[:digit:]]\+/delay=10000000/" /etc/pam.d/login 

#prevent root-owned files from accidentally becoming accessible to non priviledged users 
usermod -g 0 root 

#file permissions 
# Set /etc/passwd ownership and access permissions.
chown root:root /etc/passwd
chmod 644 /etc/passwd

# Set /etc/shadow ownership and access permissions.
chown root:shadow /etc/shadow
chmod 640 /etc/shadow

# Set /etc/group ownership and access permissions.
chown root:root /etc/group
chmod 644 /etc/group

# Set /etc/gshadow ownership and access permissions.
chown root:shadow /etc/gshadow
chmod 640 /etc/group

# Set /etc/security/opasswd ownership and access permissions.
chown root:root /etc/security/opasswd
chmod 600 /etc/security/opasswd

# Set /etc/passwd- ownership and access permissions.
chown root:root /etc/passwd-
chmod 600 /etc/passwd-

# Set /etc/shadow- ownership and access permissions.
chown root:root /etc/shadow-
chmod 600 /etc/shadow-

# Set /etc/group- ownership and access permissions.
chown root:root /etc/group-
chmod 600 /etc/group-

# Set /etc/gshadow- ownership and access permissions.
chown root:root /etc/gshadow-
chmod 600 /etc/gshadow-

#banner restrictions 
chown root:root /etc/motd
chmod 644 /etc/motd
echo "Authorized uses only. All activity may be monitored and reported." > /etc/motd
  
chown root:root /etc/issue
chmod 644 /etc/issue
echo "Authorized uses only. All activity may be monitored and reported." > /etc/issue
  
chown root:root /etc/issue.net
chmod 644 /etc/issue.net
echo "Authorized uses only. All activity may be monitored and reported." > /etc/issue.net

chmod 700 /root
chmod 700 /var/log/audit
chmod 740 /etc/sysconfig/iptables-config
chmod 740 /etc/sysconfig/firewalld
chmod 740 /sbin/iptables
chmod 700 /etc/skel
chmod 600 /etc/rsyslog.conf
chmod 640 /etc/security/access.conf
chmod 600 /etc/sysctl.conf

#Disable SSH root login and Disable SSH access via empty passwords and Enable use of priviledge separation 
#add or correct the following line in /etc/ssh/sshd_config: PermitRootLogin no 
#add or correct the following line in /etc/ssh/sshd_config: PermitEmptyPasswords no 
#add or correct the following line in the /etc/ssh/sshd_config file: UsePrivilegeSeparation yes 
#add or correct the following line in /etc/ssh/sshd_config: IgnoreUserKnownHosts yes 
#add or correct the following line in /etc/ssh/sshd_config: RhostsRSAAuthentication no 
#add or correct the following line in /etc/ssh/sshd_config: HostbasedAuthentication no  
#add or correct the following line in /etc/ssh/sshd_config: IgnoreRhosts yes 

sudo systemctl disable kdump.service 
sudo yum -y remove chrony 

#####################################################
##				Install OSquery 				#####
#####################################################
#curl -L https://pkg.osquery.io/rpm/GPG | sudo tee /etc/pki/rpm-gpg/RPM-GPG-KEY-osquery
#sudo yum -y install yum-utils 
#sudo yum-config-manager --add-repo https://pkg.osquery.io/rpm/osquery-s3-rpm.repo
#sudo yum-config-manager --enable osquery-s3-rpm
#sudo yum install osquery
#osqueryi 

#select pid, name, path from processes;

#List users, description, directory 
#select username, description, directory, type from users; 
#https://osquery.io/schema/3.3.0#users

#Networking
#select interface, address, broadcast, type, friendly_name from interface_addresses; 

#last login
#select username, time, host from last;

#TODO: combine listening_ports with processes to get PID, name, and port
#modify this:
# $osqueryi
#SELECT DISTINCT
#process.name,
#listening.port,
#process.pid
#from processes as process 
#join listening_ports as listening 
#on process.pid = listening.pid;