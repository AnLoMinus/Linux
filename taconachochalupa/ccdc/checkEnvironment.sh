#!/bin/bash
#=======================================================================================
#=== DESCIPTION ========================================================================
#=======================================================================================
	## looks for anything non-default about the environment
	## system, and shell environments
	##
#=======================================================================================
#=======================================================================================
	#
	#*************** NEED TO DO/ADD ***********************
	#### PATHs
	# root									/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin
	# users									/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin
	#******************************************************
	#
#///////////////////////////////////////////////////////////////////////////////////////
#|||||||||||||||||||||||| Script Stuff Starts |||||||||||||||||||||||||||||||||||||||||
#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
###### RUN function #######
###########################
function main(){		###
	pathSeeker			###
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
	# https://askubuntu.com/questions/275965/how-to-list-all-variables-names-and-their-current-values
	# view environment variables
		env
		<OR>
		printenv
	# view shell variables
		( set -o posix ; set ) | less
			# the () follows similar rules to math.
			#completes the part in the () before piping to less
	}
###########################################################################################
# breaking PATH var into parts and testing ownership
###########################################################################################
function pathSeeker(){
	#### Checking PATH permissions ############################
	local IFS=:

	for path in $PATH; do
		owner="$(stat -c "%U %G" "$path")"

		if [[ $owner != "root root" ]]; then
			printf "\nPATH is dirty.\n\tHave a look at [$path]"
		fi
	done
	}
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#+++++++++++++++++++++++++++++++++ FIGHT!! +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

main
