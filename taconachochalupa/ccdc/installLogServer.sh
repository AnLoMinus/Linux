#!/bin/bash
#   _           _        _ _
#  (_)         | |      | | |
#   _ _ __  ___| |_ __ _| | |
#  | | '_ \/ __| __/ _` | | |
#  | | | | \__ \ || (_| | | |
#  |_|_| |_|___/\__\__,_|_|_|
#  ██╗      ██████╗  ██████╗     ███████╗███████╗██████╗ ██╗   ██╗███████╗██████╗
#  ██║     ██╔═══██╗██╔════╝     ██╔════╝██╔════╝██╔══██╗██║   ██║██╔════╝██╔══██╗
#  ██║     ██║   ██║██║  ███╗    ███████╗█████╗  ██████╔╝██║   ██║█████╗  ██████╔╝
#  ██║     ██║   ██║██║   ██║    ╚════██║██╔══╝  ██╔══██╗╚██╗ ██╔╝██╔══╝  ██╔══██╗
#  ███████╗╚██████╔╝╚██████╔╝    ███████║███████╗██║  ██║ ╚████╔╝ ███████╗██║  ██║
#  ╚══════╝ ╚═════╝  ╚═════╝     ╚══════╝╚══════╝╚═╝  ╚═╝  ╚═══╝  ╚══════╝╚═╝  ╚═╝
######################################################
####### Installing Graylog2 Single Node Server #######
#Created: 18.09.07  (Y.M.D)
#MongoDB        = Most upto date
#Elasticsearch  = 5.x?
#Graylog2       = 2.4
#-----------------------------------------------------
# There are multiple points where it updates/installs
#this is just so i can keep each section by itself
#will probably fix that later
#=======================================================================================
#=======================================================================================
	#
	#*************** NEED TO DO/ADD ***********************
	# Add option to install Cockpit instead (or as well)
	# add nginx https reverse proxy
	# update to use newest gl2 version instead of this set one
	# break into functions
	# test if installed before trying to install again
	# test if apt-keys/repos/ppas/etc are already installed so they dont get installed multiple times
	# general clean up
	#******************************************************
	#
#///////////////////////////////////////////////////////////////////////////////////////
#|||||||||||||||||||||||| Script Stuff Starts |||||||||||||||||||||||||||||||||||||||||
#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
###### RUN function #######
###########################
#function main(){		###
#	function1			###
#	function2			###
#}						###
###########################
#------ error handling ----------
### If error, give up			#
#set -e							#
#- - - - - - - - - - - - - - - -#
### if error, do THING			#
# makes trap global 			#
# (works in functions)			#
#set -o errtrace				#
# 'exit' can be a func or cmd	#
#trap 'exit' ERR				#
#--------------------------------
#backupDir="$HOME""/ccdc_backups/$(basename -s.sh "$0")"
backupDir="$HOME""/ccdc_backups/$(echo $BASH_SOURCE | sed 's|.sh$||' | rev | cut -d\/ -f1 | rev)"
###########################################################################################
# Installing Graylog2
###########################################################################################
## POSIX option
#stty -echo
#printf "Password: "
#read password
#stty echo
#printf "\n"

serverIP=$(hostname -I | sed 's/ //')

echo ""
echo "If it fails because it thinks '-s' isn't a valid option. Open the script and switch to POSIX"
echo ""
read -s -p "Enter a Password for Graylog Site Login [admin]: " password
echo ""
read -p "Server Domain or IP [$serverIP]: " serverIP

#setting default for serverIP to be the active interface ip, if there is only one interface
: ${serverIP:=$(hostname -I | sed 's/ //')}
#setting the default for password to be 'admin'
: ${password:="admin"}
#moving to /tmp dir
  cd /tmp

#######################################################################
#prereqs
#######################################################################
sudo apt update && sudo apt upgrade -y
sudo apt install apt-transport-https openjdk-8-jre-headless uuid-runtime pwgen -y
#######################################################################
######MongoDB repo and install
#######################################################################
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2930ADAE8CAF5059EE73BB4B58712A2291FA4AD5
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.6 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.6.list
sudo apt update && sudo apt install -y mongodb-org
	#enabling and having it start with the server
		sudo systemctl daemon-reload
		sudo systemctl enable mongod.service
		sudo systemctl restart mongod.service
#######################################################################
######Elasticsearch
#######################################################################
## https://www.elastic.co/guide/en/elasticsearch/reference/5.6/deb.html
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
echo "deb https://artifacts.elastic.co/packages/5.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-5.x.list
sudo apt update && yes|sudo apt install elasticsearch
	#updating config file
		# /etc/elasticsearch/elasticsearch.yml
		# creating a backup of the original yml, just in case.
    sudo cp -a /etc/elasticsearch/elasticsearch.yml /etc/elasticsearch/elasticsearch.yml.$(date +"%Y-%m-%d_%H%M")
    sudo sed -i.bak 's/#cluster.name:.my-application/cluster.name: graylog/' /etc/elasticsearch/elasticsearch.yml
	#enabling and having it start with the server
		sudo systemctl daemon-reload
		sudo systemctl enable elasticsearch.service
		sudo systemctl restart elasticsearch.service
#######################################################################
######Graylog2 repo and install
#######################################################################
wget https://packages.graylog2.org/repo/packages/graylog-2.4-repository_latest.deb
sudo dpkg -i graylog-2.4-repository_latest.deb
sudo apt update && sudo apt install graylog-server -y

###configuring graylog
#creating a backup of he original, just in case
  sudo cp -a /etc/graylog/server/server.conf /etc/graylog/server/server.conf.$(date +"%Y-%m-%d_%H%M")
#128 character random gen password
#using the magic of sed, insert pw
	sudo -E sed -i -e "s/password_secret =.*/password_secret = $(pwgen -s 128 1)/" /etc/graylog/server/server.conf
#replace 'password' ****AND REMEMBER THE SPACE BEFORE THE COMMAND***
	 sudo sed -i -e "s/root_password_sha2 =.*/root_password_sha2 = $(echo -n "$password" | shasum -a 256 | cut -d' ' -f1)/" /etc/graylog/server/server.conf
#config changes
#  	sudo nano /etc/graylog/server/server.conf
#		rest_listen_uri = http://$serverIP:9000/api/
#		web_listen_uri = http://$serverIP:9000/
  sudo sed -i.bak "s/rest_listen_uri.=.http:\/\/127.0.0.1:9000\/api\//rest_listen_uri = http:\/\/$serverIP:9000\/api\//" /etc/graylog/server/server.conf
  sudo sed -i.bak "s/#web_listen_uri.=.http:\/\/127.0.0.1:9000\//web_listen_uri = http:\/\/$serverIP:9000\//" /etc/graylog/server/server.conf
#restarting server
	# sudo systemctl restart graylog-server
#checking status of server
	# sudo systemctl status graylog-server
#enabling and having it start with the server
	sudo systemctl daemon-reload
	sudo systemctl enable graylog-server.service
	sudo systemctl start graylog-server.service|exit

#(optional)if you have ufw configured
#	sudo ufw allow 9000/tcp

#######################################################################
######Setting UFW exception
#######################################################################
clear
echo "###If you are not sure, say no###"
while [ "$UFW" == "" ]; do
  read -p "Are you using UFW? (If you are not sure, say no) [y/N]: " UFW
: ${UFW:="n"}
  case $UFW in
    [Yy]*|*[Yy][Ee][Ss]*)
              sudo ufw allow 9000/tcp
              echo ""
              echo "applied 'sudo ufw allow 9000/tcp'"
              echo ""
              ;;
        [Nn]*|*[Nn][Oo]*)
              echo ""
              echo "making no changes then"
              echo "if that was a mistake, enter 'sudo ufw allow 9000/tcp' to allow the exception"
              echo ""
              ;;
                       *)
              echo ""
              echo "making no changes then"
              echo "if that was a mistake, enter 'sudo ufw allow 9000/tcp' to allow the exception"
              echo ""
              ;;
  esac
done

#######################################################################
######Exit Message
#######################################################################
echo ""
echo ""
echo "==================================================================================="
echo "                         ==whoopsie files made=="
echo "Orig Elasticsearch config saved to: /etc/elasticsearch/elasticsearch.yml.DATEnTIME"
echo "Orig Graylog config saved to      : /etc/graylog/server/server.conf.DATEnTIME"
echo "==================================================================================="

echo "To login, go to"
echo "      $serverIP:9000"
echo "      User = admin"
echo "      Password = <whatyouputin> || admin"
