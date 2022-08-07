#!/bin/bash
#									        _               _
#									       | |             | |
#									    ___| |__   ___  ___| | __
#									   / __| '_ \ / _ \/ __| |/ /
#									  | (__| | | |  __/ (__|   <
#									   \___|_| |_|\___|\___|_|\_\
#   ██████╗██████╗  ██████╗ ███╗   ██╗████████╗ █████╗ ██████╗ ███████╗
#  ██╔════╝██╔══██╗██╔═══██╗████╗  ██║╚══██╔══╝██╔══██╗██╔══██╗██╔════╝
#  ██║     ██████╔╝██║   ██║██╔██╗ ██║   ██║   ███████║██████╔╝███████╗
#  ██║     ██╔══██╗██║   ██║██║╚██╗██║   ██║   ██╔══██║██╔══██╗╚════██║
#  ╚██████╗██║  ██║╚██████╔╝██║ ╚████║   ██║   ██║  ██║██████╔╝███████║
#   ╚═════╝╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═══╝   ╚═╝   ╚═╝  ╚═╝╚═════╝ ╚══════╝
#=======================================================================================
#=== DESCIPTION ========================================================================
#=======================================================================================
	## lists all cronjobs for all users
	##
	##
#=======================================================================================
#=======================================================================================
	#
	#*************** NEED TO DO/ADD ***********************
	# check atjobs				cat /var/spool/cron/atjobs
	# check timers				systemctl list-timers --all
	# check 'at' jobs			atq
	#### everything
	# ,this one should have		/var/spool/cron/
	# 							find /var/spool/cron -type f -exec ls -l {} \; -exec cat {} ;\
	#### cronjobs
	#							/etc/default/cron
	#							/etc/init.d/cron
	#							/etc/cron.d/
	#							/etc/cron.daily/
	#							/etc/cron.hourly/
	#							/etc/cron.monthly/
	#							/etc/crontab
	#							/etc/cron.weekly/
	#### at jobs
	#							/var/spool/cron/atjobs
	#							/var/spool/cron/atspool
	#							/proc/loadavg
	#							/var/run/utmp
	#							/etc/at.allow
	#							/etc/at.deny
	######
	# unfuck the crontab &> loop thing
	#******************************************************
	#
#///////////////////////////////////////////////////////////////////////////////////////
#|||||||||||||||||||||||| Script Stuff Starts |||||||||||||||||||||||||||||||||||||||||
#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
###### RUN function #######
###########################
function main(){		###
	neo					###
	backupTheWorld		###
	jailer				###
	testOmatic			###
	checkCronCOMPLETE	###
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
#### global backup var ####
#backupDir="$HOME""/ccdc_backups/$(basename -s.sh "$0")"
backupDir="$HOME""/ccdc_backups/$(echo $BASH_SOURCE | sed 's|.sh$||' | rev | cut -d\/ -f1 | rev)"
###########################################################################################
######  ┌┬┐┌─┐┌─┐┌┬┐╔═╗┌┬┐┌─┐┌┬┐┬┌─┐  #####################################################
######   │ ├┤ └─┐ │ ║ ║│││├─┤ │ ││    #####################################################
######   ┴ └─┘└─┘ ┴ ╚═╝┴ ┴┴ ┴ ┴ ┴└─┘  #####################################################
# testing if the user has a crontab, then sends it to the filter ##########################
###########################################################################################
function testOmatic(){
	cronVar=$(mktemp) || exit 1		# crontab refuses to play nice otherwise
	userList=$(command compgen -u)	# gathering users
	userListEmpty=""				# just for tracking
	#### looping through crontabs #############
	for user in $userList; do
		#sending the command output to cronVar, without sending it.. somehow.. magically..
		command crontab -u $user -l &> "$cronVar"
		#testing if there is a crontab or not
		if grep -sq "no crontab" "${cronVar}" ; then
			#adding user to list without a crontab
			userListEmpty+=${user}$'\n'
		else	#crontab found
			printf "\n[Found crontab for $user]\n$(cat ${cronVar} |
					sed -ne '/For more in/,$p' |
					tail -n +3 |
					sed 's/^/\t/g'
					)"
		fi
	done
	#### results display #####################
	printf "\n\n\n============================================================\n"
	# display users with empty crontabs
	printf "\n\t[The users below did NOT have a crontab]\n"
	echo "${userListEmpty}" | column
}
###########################################################################################
######   ┬┌─┐┬┬  ┌─┐┬─┐  ##################################################################
######   │├─┤││  ├┤ ├┬┘  ##################################################################
######  └┘┴ ┴┴┴─┘└─┘┴└─  ##################################################################
# locks down cron use so none run (maybe) #################################################
###########################################################################################
function jailer(){
	dCron="/etc/cron.deny"
	dCronBak="/etc/cron.deny.bak"
	aCron="/etc/cron.allow"
	aCronBak="/etc/cron.allow.bak"
	#### cron.deny ############################
	if [ -e $dCron ]; then
		#backing up original
		command cp -a $dCron{,.bak}
		printf "\nCopied original $dCron to [$dCronBak]"
		command echo ALL > $dCron
		printf "\n\tSetting cron.deny to deny ALL"
	else
		printf "\n\tSetting cron.deny to deny ALL"
		command echo ALL > $dCron
	fi
	#### cron.allow ############################
	if [ -e $aCron ]; then
		command mv $aCron{,.bak}
		printf "\nMoved original $aCron to [$aCronBak]"
		printf "\n\tcron.allow has been removed"
	else
		printf "\n\tNo cron.allow found"
	fi
}
###########################################################################################
######  ┌┐ ┌─┐┌─┐┬┌─┬ ┬┌─┐╔╦╗┬ ┬┌─┐╦ ╦┌─┐┬─┐┬  ┌┬┐  #######################################
######  ├┴┐├─┤│  ├┴┐│ │├─┘ ║ ├─┤├┤ ║║║│ │├┬┘│   ││  #######################################
######  └─┘┴ ┴└─┘┴ ┴└─┘┴   ╩ ┴ ┴└─┘╚╩╝└─┘┴└─┴─┘─┴┘  #######################################
# backs everything up into a box and puts a bow on it #####################################
###########################################################################################
function backupTheWorld(){
	# creating the dir if it doesn't exist
	if [[ ! -d $backupDir ]]; then
		command mkdir -p "$backupDir"
	fi
	# creating ccdc backups, if they exist
	if [[ -e /etc/cron.deny ]]; then
		command cp -a /etc/cron.deny $backupDir
	fi
	if [[ -e /etc/cron.allow ]]; then
		command cp -a /etc/cron.allow $backupDir
	fi
	}
###########################################################################################
######  ┌─┐┬ ┬┌─┐┌─┐┬┌─╔═╗┬─┐┌─┐┌┐┌╔═╗╔═╗╔╦╗╔═╗╦  ╔═╗╔╦╗╔═╗ ###############################
######  │  ├─┤├┤ │  ├┴┐║  ├┬┘│ ││││║  ║ ║║║║╠═╝║  ║╣  ║ ║╣  ###############################
######  └─┘┴ ┴└─┘└─┘┴ ┴╚═╝┴└─└─┘┘└┘╚═╝╚═╝╩ ╩╩  ╩═╝╚═╝ ╩ ╚═╝ ###############################
# shouts completion info ##################################################################
###########################################################################################
function checkCronCOMPLETE(){
	printf "\nFile backups left in their dir and sent to [$backupDir]\n"
}
###########################################################################################
#are you root? no? well, try again
###########################################################################################
function neo(){
	if [[ $EUID -ne 0  ]]; then
		printf "\nyou forgot to run as root again... "
		printf "\n\tCurrent dir is [$(pwd)]\n\n"
		exit 1
	fi
}
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#+++++++++++++++++++++++++++++++++ FIGHT!! +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

main
