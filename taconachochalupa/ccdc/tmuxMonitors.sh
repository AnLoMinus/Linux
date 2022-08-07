#!/bin/bash
#=======================================================================================
#=== DESCIPTION ========================================================================
#=======================================================================================
	#### GENERAL
	## glances / nmon
	#### NETWORK
	## ss / netstat / vnstat / iftop / nethogs / bmon / nload / jnettop
	#### SYSTEM RESOURCES
	## top / htop / atop
	#### DISKS
	## dstat / discus
	#### MEMORY
	## vmstat / free / smem
	##
	##
#=======================================================================================
#=======================================================================================
	#
	#*************** NEED TO DO/ADD ***********************
	# less +F /var/log/fail2ban
	# less +F /var/log/auth.log
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
function1(){
	#..... EXAMPLES .........................................
	# creates a new session and runs 'top'
		tmux new-session -d 'top'
	# splits ABOVE window Vertically and runs 'htop'
		tmux split-window -v 'ipython'
	# splits ABOVE session Horizontally
		tmux split-window -h
	# creates a new window running 'watch netstat -tulnpa'
	#(which shows up before the ABOVE window)
		tmux new-window 'watch netstat -tulnpa'
	# forces color256 assumption, then attaches and detaches the session?
	#(not sure why the -d is there..)
		tmux -2 attach-session -d
	}
###########################################################################################
#FUNCTION2 description
###########################################################################################
function2(){
	#### PART 1 ############################
	}
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#+++++++++++++++++++++++++++++++++ FIGHT!! +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
main(){
	function1
	function2
	}
main
