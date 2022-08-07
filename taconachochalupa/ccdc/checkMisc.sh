#!/bin/bash
#=======================================================================================
#=== DESCIPTION ========================================================================
#=======================================================================================
	## checking all sorts of random stuff
	##
	##
#=======================================================================================
#=======================================================================================
	#
	#*************** NEED TO DO/ADD ***********************
	# check apt install history		/var/log/apt/history.log
	# check apt install stuff		apt-mark showmanual
	# check apt manual installs		grep -i "Commandline" /var/log/apt/history.log
	#### startup stuff
	# https://askubuntu.com/questions/218/command-to-list-services-that-start-on-startup
	# check startup services		ls /lib/systemd/system/*.service /etc/systemd/system/*.service
	# 								systemctl list-unit-files --type=service
	#								ls /etc/init.d/
	#								ls /etc/rc*.d/
	#								initctl list
	# check init script				/lib/init/init-d-script
	# check vars script				/lib/init/vars.sh
	# fstab							/etc/fstab
	#### systemctl stuff
	# check sockets					systemctl list-sockets --all
	# check units					systemctl list-units
	#### firewall stuff
	# check ufw script				vim /lib/ufw/ufw-init
	#### network stuff
	# check resolv file				/lib/systemd/network/*
	# hosts file					/etc/hosts
	#### drivers
	# dirty confs and such			/etc/modules
	#								/etc/modprobe.d/*.conf
	#								/lib/modprobe.d
	#								/lib/modules
	#								/lib/modules-load.d
	#### user agents
	# check user agents trying to connect, most/all kali tools will have their name as their user agent
	#### sudoers file				/etc/sudoers
	#								/etc/sudoers.d
	# check for any weird changes, you know the drill
	#### default files
	# debconf						/etc/debconf.conf
	# deluser						/etc/deluser.conf
	#								/etc/default/*
	# keyboard						/etc/default/keyboard
	# login defs					/etc/login.defs
	#### bash completion
	#								/usr/share/bash-completion/*
	#### HOME dirs
	# check passwd					/etc/passwd
	#### shells
	# check shells					/etc/shells
	#### keyboard shortcuts
	# 								/etc/inputrc
	# (?)							~/.inputrc
	#### grub
	# check for hidden partitions
	#or weird boot configs
	#******************************************************
	#
#///////////////////////////////////////////////////////////////////////////////////////
#|||||||||||||||||||||||| Script Stuff Starts |||||||||||||||||||||||||||||||||||||||||
#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
###### RUN function #######
###########################
function main(){		###
	function1			###
	function2			###
}						###
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
backupDir="$HOME""/ccdc_backups/$(basename "$0" | sed 's/\.sh$//')"
###########################################################################################
#FUNCTION1 description
###########################################################################################
function function1(){
	#### PART 1 ############################
	}
###########################################################################################
#FUNCTION2 description
###########################################################################################
function function2(){
	#### PART 1 ############################
	}
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#+++++++++++++++++++++++++++++++++ FIGHT!! +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

main
