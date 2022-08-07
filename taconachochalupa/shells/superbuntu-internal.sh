#!/bin/bash
#./superbuntu-internal.sh

#Change passwords 
sudo passwd ubuntu
sudo passwd root 

#add own superuser 
sudo adduser drew 
sudo adduser drew sudo

#sudo passwd drew


#Change time 
sudo dpkg-reconfigure tzdata 

#Disallow root logins over SSH
sudo echo "PermitRootLogin no" >> /etc/ssh/sshd_config
sudo echo "PasswordAuthentication no" >> /etc/ssh/sshd_config

#install! 
sudo apt-get install nmap debsecan xsltproc  -y 
#find ssh_keys 
#Find something to do with them
sudo find / |grep "\.pem"

#Debsecan scans all packages if they are exploitable, lists them all 
sudo debsecan --suite=sid 

sudo systemctl stop snapd 
sudo apt purge snapd -y 

####################################################
#				Install and start Nessus  			#
####################################################
#TODO: update the nessus reg code and make sure the directory makes sense 
cd ..
cd installs 
sudo dpkg -i Nessus-ubuntu.deb
sudo /etc/init.d/nessusd start 
sudo /opt/nessus/sbin/nessuscli fetch --register 7261-CF0A-6E86-1E8E-3064
sudo /opt/nessus/sbin/nessuscli update
sudo systemctl restart nessusd
cd ..
#######################################################

sudo nmap -v -A -T4 172.16.1.0/24 -oX ../internal.xml && sudo xsltproc ../internal.xml -o ../internal.html
sudo nmap -v -A -T4 10.1.11.0/29 -oX ../dmz.xml && sudo xsltproc ../dmz.xml -o ../dmz.html

sudo git config --global user.email "andrewku123@gmail.com"

sudo git add -A && sudo git commit -m "ubuntu server nmap scans" && sudo git push origin master 


#remove the premade superuser from sudo 
sudo deluser ubuntu sudo




 