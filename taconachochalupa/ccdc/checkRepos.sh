#!/bin/bash
#=======================================================================================
#=== DESCIPTION ========================================================================
#=======================================================================================
	## looks for any changes from the standard repo list
	## /etc/cloud/cloud.cfg
	## /etc/apt/sources.list
	## /etc/apt/sources.list.d/*
	## /etc/cloud/templates/sources.list.tmpl
#=======================================================================================
#=======================================================================================
	#
	#*************** NEED TO DO/ADD ***********************
	# if/then for ubuntu/debian and different check lists
	# remove ppas and lists that are non-standard
	# check distro
	# add lists for each distro
	# get lists of offical repos IPs
	#******************************************************
	#
#///////////////////////////////////////////////////////////////////////////////////////
#|||||||||||||||||||||||| Script Stuff Starts |||||||||||||||||||||||||||||||||||||||||
#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
###### RUN function #######
###########################
function main(){		###
	neo					###
	seeker				###
	reaper				###
	cleaner				###
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
# global backup dir
backupDir="$HOME""/ccdc_backups/$(basename "$0" | sed 's/\.sh$//')"
###########################################################################################
#are you root? no? well, try again
###########################################################################################
function neo() {
	if [[ $EUID -ne 0  ]]; then
		printf "\nyou forgot to run as root again... "
		printf "\nCurrent dir is "$(pwd)"\n\n"
		exit 1
		fi
	}
###########################################################################################
# compares to default repo list
###########################################################################################
function seeker(){
	# defining variables
	defList="Package files: 100 /var/lib/dpkg/status release a=now 500 http://security.ubuntu.com/ubuntu bionic-security/multiverse amd64 Packages release v=18.04,o=Ubuntu,a=bionic-security,n=bionic,l=Ubuntu,c=multiverse,b=amd64 origin security.ubuntu.com 500 http://security.ubuntu.com/ubuntu bionic-security/universe amd64 Packages release v=18.04,o=Ubuntu,a=bionic-security,n=bionic,l=Ubuntu,c=universe,b=amd64 origin security.ubuntu.com 500 http://security.ubuntu.com/ubuntu bionic-security/main amd64 Packages release v=18.04,o=Ubuntu,a=bionic-security,n=bionic,l=Ubuntu,c=main,b=amd64 origin security.ubuntu.com 100 http://archive.ubuntu.com/ubuntu bionic-backports/universe amd64 Packages release v=18.04,o=Ubuntu,a=bionic-backports,n=bionic,l=Ubuntu,c=universe,b=amd64 origin archive.ubuntu.com 500 http://archive.ubuntu.com/ubuntu bionic-updates/multiverse amd64 Packages release v=18.04,o=Ubuntu,a=bionic-updates,n=bionic,l=Ubuntu,c=multiverse,b=amd64 origin archive.ubuntu.com 500 http://archive.ubuntu.com/ubuntu bionic-updates/universe amd64 Packages release v=18.04,o=Ubuntu,a=bionic-updates,n=bionic,l=Ubuntu,c=universe,b=amd64 origin archive.ubuntu.com 500 http://archive.ubuntu.com/ubuntu bionic-updates/restricted amd64 Packages release v=18.04,o=Ubuntu,a=bionic-updates,n=bionic,l=Ubuntu,c=restricted,b=amd64 origin archive.ubuntu.com 500 http://archive.ubuntu.com/ubuntu bionic-updates/main amd64 Packages release v=18.04,o=Ubuntu,a=bionic-updates,n=bionic,l=Ubuntu,c=main,b=amd64 origin archive.ubuntu.com 500 http://archive.ubuntu.com/ubuntu bionic/multiverse amd64 Packages release v=18.04,o=Ubuntu,a=bionic,n=bionic,l=Ubuntu,c=multiverse,b=amd64 origin archive.ubuntu.com 500 http://archive.ubuntu.com/ubuntu bionic/universe amd64 Packages release v=18.04,o=Ubuntu,a=bionic,n=bionic,l=Ubuntu,c=universe,b=amd64 origin archive.ubuntu.com 500 http://archive.ubuntu.com/ubuntu bionic/restricted amd64 Packages release v=18.04,o=Ubuntu,a=bionic,n=bionic,l=Ubuntu,c=restricted,b=amd64 origin archive.ubuntu.com 500 http://archive.ubuntu.com/ubuntu bionic/main amd64 Packages release v=18.04,o=Ubuntu,a=bionic,n=bionic,l=Ubuntu,c=main,b=amd64 origin archive.ubuntu.com Pinned packages:"
	defListPath="$backupDir""/defList.bak"
	testList="$(apt-cache policy)"
	testListPath="$backupDir""/testList.bak"
	# creating the backup dir if it doesn't exist
	if [ ! -d $backupDir ]; then
		command mkdir -p "$backupDir"
	fi
	# backing up originals
	command cp -a /etc/cloud/cloud.cfg $backupDir/cloud.cfg.bak
	command cp -a /etc/apt/sources.list  $backupDir/sources.list.bak
	command cp -ra /etc/apt/sources.list.d/  $backupDir/sources.list.d.bak
	command cp -a /etc/cloud/templates/sources.list.debian.tmpl  $backupDir/sources.list.debian.tmpl.bak
	command cp -a /etc/cloud/templates/sources.list.ubuntu.tmpl  $backupDir/sources.list.ubuntu.tmpl.bak
	# building files
	echo $defList | sed 's/ /\n/g' > $defListPath
	echo $testList | sed 's/ /\n/g' > $testListPath
	# comparing lists
	printf "\n------ Non-Standard Repos and PPAs ------\n"
	diff <(echo $defList) <(echo $testList)
	printf "\n====== original files backed up to $backupDir--$(date +"%Y-%m-%d_%H%M") ======\n"
	}
###########################################################################################
# removes any non-standard repos/ppas
###########################################################################################
function reaper(){
	#### example ############################
	# command add-apt-repository --remove ppa:PPA_REPOSITORY_NAME/PPA
	: #lets the function be empty
	}
###########################################################################################
# zips up the backup files
###########################################################################################
function cleaner(){
	command tar -zcf $HOME/ccdc_backups/$(basename "$0" | sed 's/\.sh//')--$(date +"%Y-%m-%d_%H%M").tar.gz -C $HOME/ccdc_backups $(basename "$0" | sed 's/\.sh//')
	command rm -rf $backupDir
	}
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#+++++++++++++++++++++++++++++++++ FIGHT!! +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

main
