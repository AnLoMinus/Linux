#!/bin/bash
#   _           _        _ _
#  (_)         | |      | | |
#   _ _ __  ___| |_ __ _| | |
#  | | '_ \/ __| __/ _` | | |
#  | | | | \__ \ || (_| | | |
#  |_|_| |_|___/\__\__,_|_|_|
#  ████████╗ ██████╗  ██████╗ ██╗     ███████╗       ██╗       ███████╗███╗   ██╗██╗   ██╗
#  ╚══██╔══╝██╔═══██╗██╔═══██╗██║     ██╔════╝       ██║       ██╔════╝████╗  ██║██║   ██║
#     ██║   ██║   ██║██║   ██║██║     ███████╗    ████████╗    █████╗  ██╔██╗ ██║██║   ██║
#     ██║   ██║   ██║██║   ██║██║     ╚════██║    ██╔═██╔═╝    ██╔══╝  ██║╚██╗██║╚██╗ ██╔╝
#     ██║   ╚██████╔╝╚██████╔╝███████╗███████║    ██████║      ███████╗██║ ╚████║ ╚████╔╝
#     ╚═╝    ╚═════╝  ╚═════╝ ╚══════╝╚══════╝    ╚═════╝      ╚══════╝╚═╝  ╚═══╝  ╚═══╝
##=======================================================================================
#=== DESCIPTION ========================================================================
#=======================================================================================
	## installs normal tools
	## configures vim, ssh, etc
	## setting up aliases
########################################################################################
########################################################################################
	#
	#*************** NEED TO DO/ADD ***********************
	#### GENERAL
	## glances / nmon / pstree
	#### NETWORK
	## ss / netstat / vmstat / jnettop / nethogs / bmon / iftop / nload
	#### SYSTEM RESOURCES
	## top / htop / atop
	#### DISKS
	## dstat / discus
	#### MEMORY
	## vmstat / free /##
	######################################################
	# clean up the dumpster fire at the bottom
	# setup loops or something for checking/installing changes
	# be able to reset to defaults
	# be able to reload config before running script
	# add --help and help info
	### add installToolsAdvanced ###
	# with ALL tools i use often (broken into groups)
	#******************************************************
	#
#///////////////////////////////////////////////////////////////////////////////////////
#|||||||||||||||||||||||| Script Stuff Starts |||||||||||||||||||||||||||||||||||||||||
#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
###### RUN function #######
###########################
#	CASE SELECTION		###
#	AT THE BOTTOM		###
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
vFile="$HOME/.vimrc"
aFile="$HOME/.bash_aliases"
rcFile="$HOME/.bashrc"
sshFile="/etc/ssh/ssh_config"
###########################################################################################
######  ┬┌┐┌┌─┐┌┬┐┌─┐┬  ┬ ╔╦╗┌─┐┌─┐┬  ┌─┐╔╗ ┌─┐┌─┐┬┌─┐ ####################################
######  ││││└─┐ │ ├─┤│  │  ║ │ ││ ││  └─┐╠╩╗├─┤└─┐││   ####################################
######  ┴┘└┘└─┘ ┴ ┴ ┴┴─┘┴─┘╩ └─┘└─┘┴─┘└─┘╚═╝┴ ┴└─┘┴└─┘ ####################################
#installing basic stuff ###################################################################
###########################################################################################
function installToolsBasic(){
	sudo apt update && sudo apt install -y "autojump htop atop inxi vim net-tools
											iftop nload vnstat nmon netdiscover finger
											logwatch git curl wget shellcheck lshw
											iotop mc ncdu gdebi-core"
	# checking if autojump is already conf'd for the passed user
	function existAutojump()
		{
			if ! grep -Fx ". /usr/share/autojump/autojump.sh" $1; then
				command printf "\n\n# autojump conf\n. /usr/share/autojump/autojump.sh\n\n" >> $1
			fi
		}

	# getting all standard user dirs
	#usersHome="$(ls /home)"	#less accurate, if non dirs exist
	usersHome="$(find /home/ -mindepth 1 -maxdepth 1 -type d -printf "%f\n")"
	# setting up autojump for standard users
	for user in $usersHome; do
		rcFile="/home/$user/.bashrc"
		existAutojump $rcFile
	done
	# setting up autojump for root
	existAutojump /root/.bashrc

	# reminder to source .bashrc afterwards
	printf "\n\n\tIf autojump or aliases don't work, try doing [. ~/.bashrc]\n\n"
}
###########################################################################################
######  ┌─┐┌─┐┌┐┌┌─┐╦  ╦┬┌┬┐  #############################################################
######  │  │ ││││├┤ ╚╗╔╝││││  #############################################################
######  └─┘└─┘┘└┘└   ╚╝ ┴┴ ┴  #############################################################
#configuring vim ##########################################################################
###########################################################################################
function confVim(){
	#checking if .vimrc file exists, then inserts changes
	if [ -e $vFile ]; then
		# backing up file
		command cp -a $vFile{,.bak}

		printf "\n\nCopied Original .vimrc to:\n\t[$vFile.bak]\n"
		printf "\nNow adding the following to vim preferences:\n\n"
		# inserting changes
		if ! grep -Fxq "set number" $vFile; then echo "set number" | tee -a $vFile; fi
		if ! grep -Fxq "syntax on" $vFile; then echo "syntax on" | tee -a $vFile; fi
		if ! grep -Fxq "set tabstop=4" $vFile; then echo "set tabstop=4" | tee -a $vFile; fi
		if ! grep -Fxq "set autoindent" $vFile; then echo "set autoindent" | tee -a $vFile; fi
	else
		printf "\n\nNow adding the following to vim preferences:\n\n"
		# inserting changes
		echo "set number" | tee -a $vFile
		echo "syntax on" | tee -a $vFile
		echo "set tabstop=4" | tee -a $vFile
		echo "set autoindent" | tee -a $vFile
	fi
}
###########################################################################################
######  ┌─┐┌─┐┌┐┌┌─┐╔╗ ┌─┐┌─┐┬ ┬┬─┐┌─┐  ###################################################
######  │  │ ││││├┤ ╠╩╗├─┤└─┐├─┤├┬┘│    ###################################################
######  └─┘└─┘┘└┘└  ╚═╝┴ ┴└─┘┴ ┴┴└─└─┘  ###################################################
#configuring .bashrc ######################################################################
###########################################################################################
function confBashrc(){
	# back up the file, just in case
	command cp -a $rcFile{,.bak}
	printf "\nNow adding the following to the .bashrc:\n\n"
## pressing space auto expands ! and !! stuff
	if ! grep -Fxq "bind Space:magic-space" $rcFile; then echo "bind Space:magic-space" | tee -a $rcFile; fi
## using the arrows keys after typing something searching history that started with what you typed
	arrowSearch=$(cat <<-'EOF'

		# Lets you use arrrows to search history based on what you've already typed
		if [[ $- == *i* ]]; then
		 	bind '"\e[A": history-search-backward'
		 	bind '"\e[B": history-search-forward'
		fi

		EOF
		)
	if ! grep -q "$(echo "$arrowSearch" | sed -n 2p)" $rcFile; then echo "$arrowSearch" | tee -a $rcFile; fi

	# should reload everything for the current shell, IF script ran by sourcing
		command exec bash
}
###########################################################################################
######  ┌─┐┌┬┐┌┬┐┬┌┐┌┌─┐╔═╗┬  ┬┌─┐┌─┐  ####################################################
######  ├─┤ ││ │││││││ ┬╠═╣│  │├─┤└─┐  ####################################################
######  ┴ ┴─┴┘─┴┘┴┘└┘└─┘╩ ╩┴─┘┴┴ ┴└─┘  ####################################################
#adding aliases ###########################################################################
###########################################################################################
function addingAlias (){
	# checking if the aliases file exists already, then inserting aliases
	if [ -e $aFile ]; then
		# backing up file
		command cp -a $aFile{,.bak}

		printf "\n\nCopied Original .bash_aliases to:\n\t[$aFile.bak]\n"
		printf "\nNow adding the following to default aliases:\n\n"
		# inserting changes
		#****make this a loop****
		if ! grep -Fxq "alias cd..='cd ..'" $aFile; then echo "alias cd..='cd ..'" | tee -a $aFile; fi
		if ! grep -Fxq "alias cd-='cd -'" $aFile; then echo "alias cd-='cd -'" | tee -a $aFile; fi
		if ! grep -Fxq "alias dirs='dirs -v'" $aFile; then echo "alias dirs='dirs -v'" | tee -a $aFile; fi
		if ! grep -Fxq "alias ld='ls -lSh --group-directories-first'" $aFile; then echo "alias ld='ls -lSh --group-directories-first'" | tee -a $aFile; fi
	else
		printf "\n\nNow adding the following to default aliases:\n\n"
		# inserting changes
		echo "alias cd-='cd -'" | tee -a $aFile
		echo "alias cd..='cd ..'" | tee -a $aFile
		echo "alias dirs='dirs -v'" | tee -a $aFile
		echo "alias ld='ls -lSh --group-directories-first'" | tee -a $aFile
	fi
	# should reload everything for the current shell, IF script ran by sourcing
	command exec bash
}
###########################################################################################
######  ┌─┐┌─┐┌┐┌┌─┐╔═╗┌─┐┬ ┬╔═╗┬  ┬┌─┐┌┐┌┌┬┐  ############################################
######  │  │ ││││├┤ ╚═╗└─┐├─┤║  │  │├┤ │││ │   ############################################
######  └─┘└─┘┘└┘└  ╚═╝└─┘┴ ┴╚═╝┴─┘┴└─┘┘└┘ ┴   ############################################
#configuring ssh client ###################################################################
###########################################################################################
function confSshClient(){
	# if ssh_config file exists, edits the VisualHostKey to be ON
	if [ -e $sshFile ]; then
		command sed -ri 's/[. #](.*)(VisualHostKey).*/ \1\2 yes/' $sshFile
	# if ssh_config doesn't exists, checks for ssh install and generates file, then edits it
	else
		:
	fi
}
###########################################################################################
######  ┌┬┐┌─┐┌┐┌┬ ┬  #####################################################################
######  │││├┤ ││││ │  #####################################################################
######  ┴ ┴└─┘┘└┘└─┘  #####################################################################
#Menu #####################################################################################
###########################################################################################
function menu(){
#	read -p "What would you like to do: "
:	# lets the function stay empty
}
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#+++++++++++++++++++++++++++++++++ FIGHT!! +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# checks if the argument is blank
if [[ -z "$1" ]]; then
	menu
fi
# while the argument ISN'T blank, it checks all arguments given
while [[ "$1" != "" ]]; do
	# breaking arguments into single characters, if not --
	if [[ "$1" != "^--*" ]]; then
		args="$(echo "$1" | sed -r 's/(\w)/\1 /g')"
	else
		args="$1"
	fi
	# breaking strings into individual runs 'a b c' becomes 'a''b''c'
	for word in $args; do
		# runs arguments through selector
		case $word in
			a | --all)
							confSshClient; addingAlias
							confVim; installToolsBasic
							confBashrc
							;;
			b | --bashrc)
							confBashrc
							;;
			s | --ssh)
							confSshClient
							;;
			l | --alias)
							addingAlias
							;;
			v | --vim)
							confVim
							;;
			t | --tools)
							installToolsBasic
							;;
			* )
							menu
							;;
		esac
	done
	shift
done

## reminder to run script by sourcing it
	printf "\n\n\tIf you didn't run the script by sourcing it    [ .  script.sh ]\n\tyou have to source your .bashrc file to apply some changes :(\n\n"
