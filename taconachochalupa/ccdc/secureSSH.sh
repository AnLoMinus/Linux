#!/bin/bash
#=======================================================================================
#=== DESCIPTION ========================================================================
#=======================================================================================
	## locks down SSH logins. key access only
	## checks for currently authed keys
	## copy and replace any authed keys until they can be verified
#=======================================================================================
#=======================================================================================
	#
	#*************** NEED TO DO/ADD ***********************
	# all the stuff
	# also things
	# /etc/cloud/cloud.cfg
	# /etc/ssh/sshd_config
	# /etc/ssh/ssh_host_ecdsa_key.pub
	# ~/.ssh/authorized_keys
	# get list of ECDSA key fingerprints for your machines
	# change ssh port
	# check /etc/default/ssh
	# remove, or rename, any and all .ssh/authorized_keys files
	#******************************************************
	#
#///////////////////////////////////////////////////////////////////////////////////////
#|||||||||||||||||||||||| Script Stuff Starts |||||||||||||||||||||||||||||||||||||||||
#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
#### RUN function #####
#######################
function main(){	###
	function1		###
	function2		###
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
	# getting the host's ECDSA key fingerprint
	for file in /etc/ssh/ssh_host_ecdsa_key.pub; do
		command ssh-keygen -lf $file
	done
	# checking a target's ECDSA key fingerprint
	read -p "Host or Domain you want to check: " target

	command ssh -o VisualHostKey=yes -o FingerprintHas=sha256 $target
	}
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#+++++++++++++++++++++++++++++++++ FIGHT!! +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

main
