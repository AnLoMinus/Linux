#!/bin/bash
#./traveler.sh

#change sudo group lastttttttt!!!! 

#Change passwords 
sudo passwd ubuntu
sudo passwd root 
sudo passwd galadriel 

#add own superuser 
sudo adduser drew 
sudo adduser drew sudo

#Change time 
sudo dpkg-reconfigure tzdata 

#install! 
sudo apt-get install nmap debsecan curl build-essential git ruby bundler ruby-dev bison flex autoconf automake libpcap-dev libpq-dev zlib1g-dev libsqlite3-dev -y 

#install metasploit + armitage 
wget https://github.com/rapid7/metasploit-framework/archive/5.0.2.tar.gz  

#find ssh_keys 
#Find something to do with them
#sudo find / |grep "\.pem"

#Debsecan scans all packages if they are exploitable, lists them all 
#sudo debsecan --suite=sid 

#
chown root:root /etc/ssh/sshd_config
chmod og-rwx /etc/ssh/sshd_config

chown root:root /etc/passwd
chmod 644 /etc/passwd

chown root:shadow /etc/shadow
chmod o-rwx,g-wx /etc/shadow

chown root:root /etc/group
chmod 644 /etc/group

chown root:shadow /etc/gshadow
chmod o-rwx,g-rw /etc/gshadow

chown root:root /etc/passwd-
chmod 600 /etc/passwd-

chown root:root /etc/shadow-
chmod 600 /etc/shadow-

chown root:root /etc/group-
chmod 600 /etc/group-

chown root:root /etc/gshadow-
chmod 600 /etc/gshadow-

#Uninstall remmina 
sudo apt purge remina 
#remove galadriel's ssh key
#login to galadriel 
#vim ~/.ssh/known_hosts
#dd

sudo nmap -v -A -T4 172.16.1.0/24 -oX traveler_internal.xml && sudo xsltproc traveler_internal.xml -o traveler_internal.html
sudo nmap -v -A -T4 10.1.11.0/29 -oX traveler_dmz.xml && sudo xsltproc traveler_dmz.xml -o traveler_dmz.html

sudo git config --global user.email "andrewku123@gmail.com"

sudo git add -A && sudo git commit -m "traveler's nmap scans" && sudo git push origin master 

#Disable SSH root login and Disable SSH access via empty passwords and Enable use of priviledge separation 
#add or correct the following line in /etc/ssh/sshd_config: PermitRootLogin no 
#add or correct the following line in /etc/ssh/sshd_config: PermitEmptyPasswords no 
#add or correct the following line in the /etc/ssh/sshd_config file: UsePrivilegeSeparation yes 
#add or correct the following line in /etc/ssh/sshd_config: IgnoreUserKnownHosts yes 
#add or correct the following line in /etc/ssh/sshd_config: RhostsRSAAuthentication no 
#add or correct the following line in /etc/ssh/sshd_config: HostbasedAuthentication no  
#add or correct the following line in /etc/ssh/sshd_config: IgnoreRhosts yes 

#delete the premade superuser 
sudo deluser ubuntu sudo