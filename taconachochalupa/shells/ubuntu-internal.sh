#!/bin/bash
#./ubuntu-internal.sh
#ubuntu internal machine
#README for other machines: https://www.linode.com/docs/security/securing-your-server/

source helpers.sh

#sudo git clone https://github.com/drookoo/taconachochalupa.git
#cd taconachochalupa
#sudo chmod +x ./ubuntu-server.sh

#create a user to administer server 
sudo adduser exammple_user
sudo adduser example_user sudo 
#TODO: log into the user to perform tasks 

#Disaalow root logins over SSH
sudo vi /etc/ssh/sshd_config
# Authentication 
#
#PermitRootLogin no 

#Remove Unused Network-Facing Services 
#Determine running services 
sudo ss -atpu 
#Uninstall 
#sudo apt purge package_name 
#Run again to verify that the unwanted services are no longer running 
sudo ss -atpu 

sudo apt-get install clamav clamav-daemon -y
#wait for the virus database updater to finish 
#systemctl status clamav-freshclam 
#to scan entire system: 
#clamscan -r /
#usage see here: https://askubuntu.com/questions/250290/how-do-i-scan-for-viruses-with-clamav

sudo apt install nmap xsltproc -y
sudo nmap -v -A -T4 172.16.5.0/24 -oX internal.xml && sudo xsltproc internal.xml -o internal.html
sudo nmap -v -A -T4 10.5.11.0/28 -oX dmz.xml && sudo xsltproc dmz.xml -o dmz.html

sudo git config --global user.email "andrewku123@gmail.com"
sudo git add -A && sudo git commit -m "ubuntu server nmap scans" && sudo git push origin master 

#configure timezone
dpkg-reconfigure tzdata
   
# Update System, Install sysv-rc-conf tool
update_system(){
	clear
	echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
	echo -e "\e[93m[+]\e[00m Updating the System"
	echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
	echo ""
	apt update
	apt upgrade -y
	apt dist-upgrade -y
	say_done
	}

##############################################################################################################

#Disabling Unused Filesystems

unused_filesystems(){
	clear
	echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
	echo -e "\e[93m[+]\e[00m Disabling Unused FileSystems"
	echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
	echo ""
	spinner
	echo "install cramfs /bin/true" >> /etc/modprobe.d/CIS.conf
	echo "install freevxfs /bin/true" >> /etc/modprobe.d/CIS.conf
	echo "install jffs2 /bin/true" >> /etc/modprobe.d/CIS.conf
	echo "install hfs /bin/true" >> /etc/modprobe.d/CIS.conf
	echo "install hfsplus /bin/true" >> /etc/modprobe.d/CIS.conf
	echo "install squashfs /bin/true" >> /etc/modprobe.d/CIS.conf
	echo "install udf /bin/true" >> /etc/modprobe.d/CIS.conf
	echo "install vfat /bin/true" >> /etc/modprobe.d/CIS.conf
	echo " OK"
	say_done
	}

##############################################################################################################

# Disable Compilers
disable_compilers(){
	clear
	echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
	echo -e "\e[93m[+]\e[00m Disabling Compilers"
	echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
	echo ""
	echo "Disabling Compilers....."
	spinner
	chmod 000 /usr/bin/as >/dev/null 2>&1
	chmod 000 /usr/bin/byacc >/dev/null 2>&1
	chmod 000 /usr/bin/yacc >/dev/null 2>&1
	chmod 000 /usr/bin/bcc >/dev/null 2>&1
	chmod 000 /usr/bin/kgcc >/dev/null 2>&1
	chmod 000 /usr/bin/cc >/dev/null 2>&1
	chmod 000 /usr/bin/gcc >/dev/null 2>&1
	chmod 000 /usr/bin/*c++ >/dev/null 2>&1
	chmod 000 /usr/bin/*g++ >/dev/null 2>&1
	spinner
	echo ""
	echo " If you wish to use them, just change the Permissions"
	echo " Example: chmod 755 /usr/bin/gcc "
	echo " OK"
	say_done
	}

##############################################################################################################

file_permissions(){
	clear
	echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
	echo -e "\e[93m[+]\e[00m Setting File Permissions on Critical System Files"
	echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
	echo ""
	spinner
	sleep 2

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
	
	echo -e ""
	echo -e "Setting Sticky bit on all world-writable directories"
	sleep 2
	spinner

	df --local -P | awk {'if (NR!=1) print $6'} | xargs -I '{}' find '{}' -xdev -type d -perm -0002 2>/dev/null | xargs chmod a+t

	echo " OK"
	say_done

	}
##############################################################################################################

admin_user(){
    clear
    echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
    echo -e "\e[93m[+]\e[00m We will now Create a New User"
    echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
    echo ""
    echo -n " Type the new username: "; read username
    adduser $username
	adduser $username sudo 
    say_done
}
								   
config_timezone
# update_system
unused_filesystems
disable_compilers
file_permissions

#check ports open and services 
sudo netstat -lantp 

#list # of patches available
sudo apt update 

# list name of patches available 
sudo apt list --upgradeable 

#list past upgrades, saves to file
grep " installed " /var/log/dpkg.log > installed.txt

#list ALL local users, no jargon 
cut -d: -f1 /etc/passwd

#list ALL normal (non-system, non-weird) users 
awk -F'[/:]' '{if ($3 >= 1000 && $3 != 65534) print $1}' /etc/passwd

#list system + weird users
awk -F'[/:]' '{if ($3 <= 999) print $1}' /etc/passwd

#Delete the user and all files owned by the user on the whole system 
#sudo deluser --remove-all-files ccdc

#check who is currently loggedin 
w 

#check login history
lastlog 


#!/bin/bash 
#TODO: put osquery install files into /installs/ for easy retrieval

git clone https://fail2ban/fail2ban.git
cd fail2ban
sudo apt install python -y
sudo python setup.py install 

sudo cp /etc/fail2ban/fail2ban.conf /etc/fail2ban/fail2ban.local
sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local

#make sure you are in the fail2ban directory

sudo cp files/debian-initd /etc/init.d/fail2ban
sudo update-rc.d fail2ban defaults
service fail2ban start

# make changes to .local, not to .conf b/c .conf gets read first, but .local overrides any settings 

vi /etc/fail2ban/fail2ban.local 

#[sshd]
#port = ssh
#logpath = %(sshd_log)s
#backend = %(sshd_backend)s 
#enabled = true 

#Restart to apply any changes 
#sudo fail2ban-client restart 

#Verify 
#sudo fail2ban-client status 
#systemctl systemctl status fail2ban 



#########################################

# OSQuery

#########################################

#Install
wget https://pkg.osquery.io/deb/osquery_3.3.0_1.linux.amd64.deb
sudo dpkg -i osquery_3.3.0_1.linux.amd64.deb

systemctl start osquerd.service 

#To use osquery shell 
osqueryi 

#select pid, name, path from processes;

#List users, description, directory 
select username, description, directory, type from users; 
#https://osquery.io/schema/3.3.0#users

#Networking
select interface, address, broadcast, type, friendly_name from interface_addresses; 

#last login
select username, time, host from last;

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


#Webmap-NMap Install
#Make sure docker is installed already on the machine 
sudo mkdir /temp/webmap
sudo docker run -d --name webmap -h webmap -p 8000:8000 -v /tmp/webmap:/opt/xml rev3rse/webmap 
#Generate token 
sudo docker exec -ti webmap /root/token
#Go to another machine on the internal network and go to the machine's ip address:port 


# Bloodhound Install 
# sudo apt-get install wget curl git 
# sudo wget -O - https://debian.neo4j.org/neotechnology.gpg.key | sudo apt-key add - 
# sudo echo 'deb https://debian.neo4j.org/repo stable/' | sudo tee /etc/apt/sources.list.d/neo4j.list 
# will take long time maybe 
# sudo add-apt-repository universe 
# sudo apt-get update
# sudo apt install openjdk-8-jre-headless neo4j -y 
# IF YOU LOCKED /ETC/ YOU MUST PUT A PASSWORD ON ROOT AND THEN SU INTO ROOT to perform the following echo() 
# su 
# sudo echo "dbms.active_database=graph.db" >> /etc/neo4j/neo4j.conf
# sudo echo "dbms.connector.http.listen_address=:::7474" >> /etc/neo4j/neo4j.conf
# sudo echo "dbms.connector.bolt.listen_address=:::7687" >> /etc/neo4j/neo4j.conf
# sudo echo "dbms.allow_format_migration=true" >> /etc/neo4j/neo4j.conf 
# leave su 
# exit 
# sudo git clone https://github.com/adaptivethreat/BloodHound.git
# cd BloodHound
# mkdir /var/lib/neo4j/data/databases/graph.db #should say already exists 
# sudo cp -R BloodHoundExampleDB.graphdb/* /var/lib/neo4j/data/databases/graph.db
# sudo neo4j start 

# curl -sL https://deb.nodesource.com/setup_11.x | sudo -E bash -
# sudo apt-get install gcc make g++ nodejs -y
# sudo npm install -g electron-packager
# inside the bloodhound folder 
# su
# sudo npm install 
# sudo npm audit fix 
# sudo npm run linuxbuild







