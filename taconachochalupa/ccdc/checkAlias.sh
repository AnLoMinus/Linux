#!/bin/bash
#				        _               _
#				       | |             | |
#				    ___| |__   ___  ___| | __
#				   / __| '_ \ / _ \/ __| |/ /
#				  | (__| | | |  __/ (__|   <
#				   \___|_| |_|\___|\___|_|\_\
#   █████╗ ██╗     ██╗ █████╗ ███████╗
#  ██╔══██╗██║     ██║██╔══██╗██╔════╝
#  ███████║██║     ██║███████║███████╗
#  ██╔══██║██║     ██║██╔══██║╚════██║
#  ██║  ██║███████╗██║██║  ██║███████║
#  ╚═╝  ╚═╝╚══════╝╚═╝╚═╝  ╚═╝╚══════╝
#=======================================================================================
#=== DESCIPTION ========================================================================
#=======================================================================================
	## check what users exist, logs them, then prints any non-standard users
#=======================================================================================
#=======================================================================================
	#
	#*************** NEED TO DO/ADD ***********************
	# need to "manually" check all "$HOME"/.bashrc    "$HOME"/.bash_profile    "$HOME"/.bash_aliases
	# /root/.bashrc
	# and check for anything in   /etc/aliases  /etc/profile    /etc/bashrc    /etc/profile.d
	# check any temporary aliases
	# clean up syntax and what not
	# ignore order of aliases
	#******************************************************
	#
#///////////////////////////////////////////////////////////////////////////////////////
#|||||||||||||||||||||||| Script Stuff Starts |||||||||||||||||||||||||||||||||||||||||
#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
#### RUN function #####
#######################
function main(){	###
	buildEmUp		###
#	whoDat			###
	breakEmDown		###
}					###
#######################
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
backupDir=""$HOME"""/ccdc_backups/$(basename "$0" | sed 's/\.sh$//')"
###########################################################################################
######  ┌┐ ┬ ┬┬┬  ┌┬┐╔═╗┌┬┐╦ ╦┌─┐  ########################################################
######  ├┴┐│ │││   ││║╣ │││║ ║├─┘  ########################################################
######  └─┘└─┘┴┴─┘─┴┘╚═╝┴ ┴╚═╝┴    ########################################################
# builds the 2 files for diff to check and copies them to a backup archive ################
###########################################################################################
function buildEmUp(){
	printf "\n==============================================="
	printf "\n====== List of Non-Standard Alias in Use ======\n"
	printf "===============================================\n"
	# creating backup dir, if needed
		if [ ! -d "$backupDir" ]; then
			command mkdir -p "$backupDir"
		fi
	#--------------------------
	defList="alias ls='ls --color=auto' alias grep='grep --color=auto' alias fgrep='fgrep --color=auto' alias egrep='egrep --color=auto' alias ll='ls -alF' alias la='ls -A' alias l='ls -CF' alias alert='notify-send --urgency=low -i \"\$([ \$? = 0 ] && echo terminal || echo error)\" \"\$(history|tail -n1|sed -e '\\''s/^\\s*[0-9]\\+\\s*//;s/[;&|]\\s*alert\$//'\\'')\"'"
	userList="$(find /home/ -mindepth 1 -maxdepth 1 -type d) /root"

	# checking all users
	for user in $userList; do
		homeDir="$user"
		userName="$(echo "$user" | rev | cut -d/ -f1 | rev)"
		testList="$(cat $homeDir/.bashrc | grep -P "^[\t ]*alias.+")"
		defListPath=""$backupDir"/"$userName"-defList.bak"
		testListPath=""$backupDir"/"$userName"-testList.bak"

		# creating defList file
			echo "$defList" > "$defListPath"
			command sed -i 's/ alias/\nalias/g' "$defListPath"

		command cp -a "$homeDir"/.bashrc{,.bak}						#leaves a copy in their dir
		command cp -a "$homeDir"/.bashrc "$backupDir"/bashrc.bak	#backup to ccdc dir
		# backup the .bash_aliases file if it exists
		if [ -f "$homeDir"/.bash_aliases ]; then
			command cp -a "$homeDir"/.bash_aliases{,.bak}
			command cp -a "$homeDir"/.bash_aliases "$backupDir"/"$userName"-bash_aliases.bak
		fi
	# creating file
		echo "$testList" > "$testListPath"
		command sed -i 's/^\s*//g' "$testListPath"
	# displaying differences for each user
		whoDat
	done
}
###########################################################################################
######  ┬ ┬┬ ┬┌─┐╔╦╗┌─┐┌┬┐  ###############################################################
######  │││├─┤│ │ ║║├─┤ │   ###############################################################
######  └┴┘┴ ┴└─┘═╩╝┴ ┴ ┴   ###############################################################
# comparing defined list and generated list ###############################################
###########################################################################################
function whoDat(){
	printf "\n["$user"]\n"
# compares standard aliases against .bashrc file
	command diff "$defListPath" "$testListPath" | grep ">"
# displays .bash_aliases file if it exists for the user
	if [ -e "$homeDir"/.bash_aliases ]; then
		printf "\n\t---- from .bash_aliases --------------\n"
		command cat "$homeDir"/.bash_aliases | sed 's/^/\t/g'
		printf "\t--------------------------------------\n"
	fi
	}
###########################################################################################
######  ┌┐ ┬─┐┌─┐┌─┐┬┌─╔═╗┌┬┐╔╦╗┌─┐┬ ┬┌┐┌  ################################################
######  ├┴┐├┬┘├┤ ├─┤├┴┐║╣ │││ ║║│ │││││││  ################################################
######  └─┘┴└─└─┘┴ ┴┴ ┴╚═╝┴ ┴═╩╝└─┘└┴┘┘└┘  ################################################
# zipping and removing old files ##########################################################
###########################################################################################
function breakEmDown(){
	printf "\n========================================================================================"
	printf "\n====== original files backed up to "$backupDir"--"$(date +"%Y-%m-%d_%H%M")" ======"
	printf "\n========================================================================================\n\n"
	command tar -zcf "$HOME"/ccdc_backups/"$(basename "$0" | sed 's/\.sh//')"--"$(date +"%Y-%m-%d_%H%M")".tar.gz -C "$HOME"/ccdc_backups "$(basename "$0" | sed 's/\.sh//')"
	#command rm -rf "$backupDir"
}
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#+++++++++++++++++++++++++++++++++ FIGHT!! +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

main
