#!/bin/bash
#				 ___  ___  ___ _   _ _ __ ___
#				/ __|/ _ \/ __| | | | '__/ _ \
#				\__ \  __/ (__| |_| | | |  __/
#				|___/\___|\___|\__,_|_|  \___|
#  ██╗██████╗ ████████╗ █████╗ ██████╗ ██╗     ███████╗███████╗
#  ██║██╔══██╗╚══██╔══╝██╔══██╗██╔══██╗██║     ██╔════╝██╔════╝
#  ██║██████╔╝   ██║   ███████║██████╔╝██║     █████╗  ███████╗
#  ██║██╔═══╝    ██║   ██╔══██║██╔══██╗██║     ██╔══╝  ╚════██║
#  ██║██║        ██║   ██║  ██║██████╔╝███████╗███████╗███████║
#  ╚═╝╚═╝        ╚═╝   ╚═╝  ╚═╝╚═════╝ ╚══════╝╚══════╝╚══════╝
#=======================================================================================
#=== DESCIPTION ========================================================================
	## saves current iptables settings
	## applies specified rules and config changes
	## pay no attention to obvious fuckups.. im sure i had a reason and didn't just derp >.>
#=======================================================================================
#=======================================================================================
	#
	#*************** NEED TO DO/ADD ***********************
	# test non-ubuntu18.04
	# cry as you realize you have to redo everything for compatibility
	# sed configs and make necessary changes
	# add ipv6 support
	# error checking for wrong read entry
	# garbage collection for rules backups
	# clean up how the iptable rules get applied. still very slow..
	# add limits to port hits
	# add options to skip the prompts
	# install and configure fail2ban. probably should have done this first.. but meh
	# netmask on intIP (trying $(hostname - I)/24 adds a trailing space "x.x.x.x /24" and causes some weirdness
	# better exit info upon completion
	# figure out why iptables -L is so slow after adding the INPUT drop rule
	# find gateway and put it where it needs to be for allowing proper ntp and dns
	# deal wiht fuckups caused by launching with sh instead of bash
	# have the first backup of each file be specially named, then tested for existence
	# consolidate rules
	#******************************************************
	#
#///////////////////////////////////////////////////////////////////////////////////////
#|||||||||||||||||||||||| Script Stuff Starts |||||||||||||||||||||||||||||||||||||||||
#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
###### RUN function #######
###########################
function main() {		###
	neo					###
	makeItSo			###
	backupTheWorld		###
	whatWeDoin			###
	summary				###
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
######  ┌┬┐┌─┐┬┌─┌─┐╦┌┬┐╔═╗┌─┐  ###########################################################
######  │││├─┤├┴┐├┤ ║ │ ╚═╗│ │  ###########################################################
######  ┴ ┴┴ ┴┴ ┴└─┘╩ ┴ ╚═╝└─┘  ###########################################################
#checking for, and installing, iptables/persistence/fail2ban ##############################
###########################################################################################
function makeItSo() {
	if ! dpkg-query -W -f='${Status}' iptables | grep -q "ok installed"; then
		apt install iptables -y
		echo ""
	fi
	if ! dpkg-query -W -f='${Status}' iptables-persistent | grep -q "ok installed"; then
		apt install iptables-persistent -y
		echo ""
	fi
	#if ! dpkg-query -W -f='${Status}' fail2ban | grep -q "ok installed"; then
		#apt install fail2ban -y
		#echo ""
	#fi
}
###########################################################################################
######  ┌┐ ┌─┐┌─┐┬┌─┬ ┬┌─┐╔╦╗┬ ┬┌─┐╦ ╦┌─┐┬─┐┬  ┌┬┐  #######################################
######  ├┴┐├─┤│  ├┴┐│ │├─┘ ║ ├─┤├┤ ║║║│ │├┬┘│   ││  #######################################
######  └─┘┴ ┴└─┘┴ ┴└─┘┴   ╩ ┴ ┴└─┘╚╩╝└─┘┴└─┴─┘─┴┘  #######################################
#backing up whatever the current settings are #############################################
###########################################################################################
function backupTheWorld() {
	if [ ! -e /firewall/rules ]; then   #checking if /firewall/rules exists
		mkdir -p /firewall/rules        #creating it
	fi
		iptables-save > /firewall/rules/autoSaved--$(date +"YMD,%Y-%m-%d_%H%M").rules
	echo ""
	echo "========================================================================|"
	echo "Saved current iptable to /firewall/rules/autosaved--$(date +"YMD,%Y-%m-%d_%H%M")|"
	echo "========================================================================|"
}
###########################################################################################
######  ┬ ┬┬ ┬┌─┐┌┬┐╦ ╦┌─┐╔╦╗┌─┐┬┌┐┌  #####################################################
######  │││├─┤├─┤ │ ║║║├┤  ║║│ │││││  #####################################################
######  └┴┘┴ ┴┴ ┴ ┴ ╚╩╝└─┘═╩╝└─┘┴┘└┘  #####################################################
#selecting our server type so we know which rules to use ##################################
###########################################################################################
#TS: if shit gets wonky, if you have multiple live interfaces, that is likely the cause.. working on it..
#----------------------
function whatWeDoin() {
	#### Empty ############################
	function empty()
	{
		"cat" <<-EOF > /etc/iptables/rules.v4
			*mangle
			:PREROUTING ACCEPT [0:0]
			:INPUT ACCEPT [0:0]
			:FORWARD ACCEPT [0:0]
			:OUTPUT ACCEPT [0:0]
			:POSTROUTING ACCEPT [0:0]
			COMMIT
			*nat
			:PREROUTING ACCEPT [0:0]
			:OUTPUT ACCEPT [0:0]
			:POSTROUTING ACCEPT [0:0]
			COMMIT
			*filter
			:INPUT ACCEPT [0:0]
			:FORWARD ACCEPT [0:0]
			:OUTPUT ACCEPT [0:0]
			COMMIT
			EOF
		"iptables-restore" /etc/iptables/rules.v4
	}
	#### Standard ############################
	function standard()
	{
		"cat" <<-EOF > /etc/iptables/rules.v4
			*mangle
			:PREROUTING ACCEPT [0:0]
			:INPUT ACCEPT [0:0]
			:FORWARD ACCEPT [0:0]
			:OUTPUT ACCEPT [0:0]
			:POSTROUTING ACCEPT [0:0]
			COMMIT
			*nat
			:PREROUTING ACCEPT [0:0]
			:OUTPUT ACCEPT [0:0]
			:POSTROUTING ACCEPT [0:0]
			COMMIT
			*filter
			:INPUT DROP [0:0]
			## allows established connections
			-A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
			## drop null packets
			#-A INPUT -p tcp --tcp-flags ALL NONE -j DROP
			## drop syn-flood packets
			#-A INPUT -p tcp ! --syn -m state --state NEW -j DROP
			## drop xmas tree packets
			#-A INPUT -p tcp --tcp-flags ALL ALL -j DROP
			### SSH Stuff ###
			## TCP packets are going to come in, that will attempt to establish an SSH connection.  Mark them as SSH.  Pay attention to the source of the packet.
			-A INPUT -p tcp -m tcp --dport 22 -m state --state NEW -m recent --set --name SSH --rsource
			## If a packet attempting to establish an SSH connection comes, and it's the fourth packet to come from the same source in 300 seconds, just reject it with prejudice and stop thinking about it.
			-A INPUT -p tcp -m tcp --dport 22 -m recent --rcheck --seconds 300 --hitcount 4 --rttl --name SSH --rsource -j REJECT --reject-with tcp-reset
			## If an SSH connection packet comes in, and it's the third attempt from the same guy in 15 seconds, log it to the system log once, then immediately reject it and forget about it.
			-A INPUT -p tcp -m tcp --dport 22 -m recent --rcheck --seconds 15 --hitcount 3 --rttl --name SSH --rsource -j LOG --log-prefix "SSH BRUTE FORCE "
			-A INPUT -p tcp -m tcp --dport 22 -m recent --update --seconds 15 --hitcount 3 --rttl --name SSH --rsource -j REJECT --reject-with tcp-reset
			## If an SSH connection has made it this far, ACCEPT it.
			-A INPUT -p tcp -m tcp --dport 22 -j ACCEPT
			###########
			## allow ping replies
			-A INPUT -p icmp --icmp-type 8 -j ACCEPT
			:FORWARD DROP [0:0]
			:OUTPUT ACCEPT [0:0]
			COMMIT
			EOF
		"iptables-restore" /etc/iptables/rules.v4
	}
	#### Attacker ############################
	function atk()
	{
		"cat" <<-EOF > /etc/iptables/rules.v4
			*mangle
			:PREROUTING ACCEPT [0:0]
			:INPUT ACCEPT [0:0]
			:FORWARD ACCEPT [0:0]
			:OUTPUT ACCEPT [0:0]
			:POSTROUTING ACCEPT [0:0]
			COMMIT
			*nat
			:PREROUTING ACCEPT [0:0]
			:OUTPUT ACCEPT [0:0]
			:POSTROUTING ACCEPT [0:0]
			COMMIT
			*filter
			:INPUT DROP [0:0]
			## allows established connections
			-A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
			## drop null packets
			#-A INPUT -p tcp --tcp-flags ALL NONE -j DROP
			## drop syn-flood packets
			#-A INPUT -p tcp ! --syn -m state --state NEW -j DROP
			## drop xmas tree packets
			#-A INPUT -p tcp --tcp-flags ALL ALL -j DROP
			### SSH Stuff ###
			## TCP packets are going to come in, that will attempt to establish an SSH connection.  Mark them as SSH.  Pay attention to the source of the packet.
			-A INPUT -p tcp -m tcp --dport 22 -m state --state NEW -m recent --set --name SSH --rsource
			## If a packet attempting to establish an SSH connection comes, and it's the fourth packet to come from the same source in 300 seconds, just reject it with prejudice and stop thinking about it.
			-A INPUT -p tcp -m tcp --dport 22 -m recent --rcheck --seconds 300 --hitcount 4 --rttl --name SSH --rsource -j REJECT --reject-with tcp-reset
			## If an SSH connection packet comes in, and it's the third attempt from the same guy in 15 seconds, log it to the system log once, then immediately reject it and forget about it.
			-A INPUT -p tcp -m tcp --dport 22 -m recent --rcheck --seconds 15 --hitcount 3 --rttl --name SSH --rsource -j LOG --log-prefix "SSH BRUTE FORCE "
			-A INPUT -p tcp -m tcp --dport 22 -m recent --update --seconds 15 --hitcount 3 --rttl --name SSH --rsource -j REJECT --reject-with tcp-reset
			## If an SSH connection has made it this far, ACCEPT it.
			-A INPUT -p tcp -m tcp --dport 22 -j ACCEPT
			######
			:FORWARD DROP [0:0]
			:OUTPUT ACCEPT [0:0]
			COMMIT
			EOF
		"iptables-restore" /etc/iptables/rules.v4
	}
	#### Website ############################
	function web()
	{
		"cat" <<-EOF > /etc/iptables/rules.v4
			*mangle
			:PREROUTING ACCEPT [0:0]
			:INPUT ACCEPT [0:0]
			:FORWARD ACCEPT [0:0]
			:OUTPUT ACCEPT [0:0]
			:POSTROUTING ACCEPT [0:0]
			COMMIT
			*nat
			:PREROUTING ACCEPT [0:0]
			:OUTPUT ACCEPT [0:0]
			:POSTROUTING ACCEPT [0:0]
			COMMIT
			*filter
			:INPUT DROP [0:0]
			## allows established connections
			-A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
			## drop null packets
			#-A INPUT -p tcp --tcp-flags ALL NONE -j DROP
			## drop syn-flood packets
			#-A INPUT -p tcp ! --syn -m state --state NEW -j DROP
			## drop xmas tree packets
			#-A INPUT -p tcp --tcp-flags ALL ALL -j DROP
			### SSH Stuff
			## TCP packets are going to come in, that will attempt to establish an SSH connection.  Mark them as SSH.  Pay attention to the source of the packet.
			-A INPUT -p tcp -m tcp --dport 22 -m state --state NEW -m recent --set --name SSH --rsource
			## If a packet attempting to establish an SSH connection comes, and its the fourth packet to come from the same source in 300 seconds, just reject it with prejudice and stop thinking about it.
			-A INPUT -p tcp -m tcp --dport 22 -m recent --rcheck --seconds 300 --hitcount 4 --rttl --name SSH --rsource -j REJECT --reject-with tcp-reset
			## If an SSH connection packet comes in, and its the third attempt from the same guy in 15 seconds, log it to the system log once, then immediately reject it and forget about it.
			-A INPUT -p tcp -m tcp --dport 22 -m recent --rcheck --seconds 15 --hitcount 3 --rttl --name SSH --rsource -j LOG --log-prefix "SSH BRUTE FORCE "
			-A INPUT -p tcp -m tcp --dport 22 -m recent --update --seconds 15 --hitcount 3 --rttl --name SSH --rsource -j REJECT --reject-with tcp-reset
			## If an SSH connection has made it this far, ACCEPT it.
			-A INPUT -p tcp -m tcp --dport 22 -j ACCEPT
			#########
			## open http/https web server port
			-A INPUT -p tcp --dport 80 -j ACCEPT
			-A INPUT -p tcp --dport 443 -j ACCEPT
			## allows ping replies
			-A INPUT -p icmp --icmp-type 8 -j ACCEPT
			## logs... something?
			-A INPUT -m limit --limit 5/min -j LOG --log-prefix "FART-OVERLOAD " --log-level 7
			:FORWARD DROP [0:0]
			:OUTPUT ACCEPT [0:0]
			COMMIT
			EOF
		"iptables-restore" /etc/iptables/rules.v4
	}
	#### Mail Server ############################
	function mail()
	{
		"cat" <<-EOF > /etc/iptables/rules.v4
			*mangle
			:PREROUTING ACCEPT [0:0]
			:INPUT ACCEPT [0:0]
			:FORWARD ACCEPT [0:0]
			:OUTPUT ACCEPT [0:0]
			:POSTROUTING ACCEPT [0:0]
			COMMIT
			*nat
			:PREROUTING ACCEPT [0:0]
			:OUTPUT ACCEPT [0:0]
			:POSTROUTING ACCEPT [0:0]
			COMMIT
			*filter
			:INPUT DROP [0:0]
			## allows established connections
			-A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
			## drop null packets
			#-A INPUT -p tcp --tcp-flags ALL NONE -j DROP
			## drop syn-flood packets
			#-A INPUT -p tcp ! --syn -m state --state NEW -j DROP
			## drop xmas tree packets
			#-A INPUT -p tcp --tcp-flags ALL ALL -j DROP
			### SSH Stuff
			## TCP packets are going to come in, that will attempt to establish an SSH connection.  Mark them as SSH.  Pay attention to the source of the packet.
			-A INPUT -p tcp -m tcp --dport 22 -m state --state NEW -m recent --set --name SSH --rsource
			## If a packet attempting to establish an SSH connection comes, and its the fourth packet to come from the same source in 300 seconds, just reject it with prejudice and stop thinking about it.
			-A INPUT -p tcp -m tcp --dport 22 -m recent --rcheck --seconds 300 --hitcount 4 --rttl --name SSH --rsource -j REJECT --reject-with tcp-reset
			## If an SSH connection packet comes in, and its the third attempt from the same guy in 15 seconds, log it to the system log once, then immediately reject it and forget about it.
			-A INPUT -p tcp -m tcp --dport 22 -m recent --rcheck --seconds 15 --hitcount 3 --rttl --name SSH --rsource -j LOG --log-prefix "SSH BRUTE FORCE "
			-A INPUT -p tcp -m tcp --dport 22 -m recent --update --seconds 15 --hitcount 3 --rttl --name SSH --rsource -j REJECT --reject-with tcp-reset
			## If an SSH connection has made it this far, ACCEPT it.
			-A INPUT -p tcp -m tcp --dport 22 -j ACCEPT
			#######
			## allows smtp
			-A INPUT -p tcp -m tcp --dport 25 -j ACCEPT
			## allows imap
			-A INPUT -p tcp -m tcp --dport 143 -j ACCEPT
			## allows pop3
			-A INPUT -p tcp -m tcp --dport 110 -j ACCEPT
			## allows ping replies
			-A INPUT -p icmp -m icmp --icmp-type 8 -j ACCEPT
			## logs... something?
			-A INPUT -m limit --limit 5/min -j LOG --log-prefix "FART-OVERLOAD " --log-level 7
			:FORWARD DROP [0:0]
			:OUTPUT ACCEPT [0:0]
			COMMIT
			EOF
		"iptables-restore" /etc/iptables/rules.v4
	}
	#### Router ############################
	function router()
	{
		read -p "Mail Server IP: " mailIP
		read -p "Web Server IP: " webIP
		read -p "Allowed SOURCE for SSH connections[192.168.0.0/24]: " sshIP
		: ${sshIP:="192.168.0.0/24"}
		"cat" <<-EOF > /etc/iptables/rules.v4
			*mangle
			:PREROUTING ACCEPT [0:0]
			:INPUT ACCEPT [0:0]
			:FORWARD ACCEPT [0:0]
			:OUTPUT ACCEPT [0:0]
			:POSTROUTING ACCEPT [0:0]
			COMMIT
			*nat
			:PREROUTING ACCEPT [0:0]
			:OUTPUT ACCEPT [0:0]
			:POSTROUTING ACCEPT [0:0]
			COMMIT
			*filter
			:INPUT DROP [0:0]
			## allows established connections
			-A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
			## drop null packets
			#-A INPUT -p tcp --tcp-flags ALL NONE -j DROP
			## drop syn-flood packets
			#-A INPUT -p tcp ! --syn -m state --state NEW -j DROP
			## drop xmas tree packets
			#-A INPUT -p tcp --tcp-flags ALL ALL -j DROP
			### SSH Stuff
			## TCP packets are going to come in, that will attempt to establish an SSH connection.  Mark them as SSH.  Pay attention to the source of the packet.
			-A INPUT -p tcp -m tcp --dport 22 -m state --state NEW -m recent --set --name SSH --rsource
			## If a packet attempting to establish an SSH connection comes, and its the fourth packet to come from the same source in 300 seconds, just reject it with prejudice and stop thinking about it.
			-A INPUT -p tcp -m tcp --dport 22 -m recent --rcheck --seconds 300 --hitcount 4 --rttl --name SSH --rsource -j REJECT --reject-with tcp-reset
			## If an SSH connection packet comes in, and its the third attempt from the same guy in 15 seconds, log it to the system log once, then immediately reject it and forget about it.
			-A INPUT -p tcp -m tcp --dport 22 -m recent --rcheck --seconds 15 --hitcount 3 --rttl --name SSH --rsource -j LOG --log-prefix "SSH BRUTE FORCE "
			-A INPUT -p tcp -m tcp --dport 22 -m recent --update --seconds 15 --hitcount 3 --rttl --name SSH --rsource -j REJECT --reject-with tcp-reset
			## If an SSH connection has made it this far, ACCEPT it.
			-A INPUT -p tcp -m tcp --dport 22 -j ACCEPT
			#######
			## allows ping replies
			-A INPUT -p icmp -m icmp --icmp-type 8 -j ACCEPT
			## logs... something?
			-A INPUT -m limit --limit 5/min -j LOG --log-prefix "FART-OVERLOAD " --log-level 7
			:FORWARD DROP [0:0]
			-A FORWARD -p tcp -d $mailIP --dport 25 -j ACCEPT
			-A FORWARD -p tcp -d $mailIP --dport 110 -j ACCEPT
			-A FORWARD -p tcp -d $mailIP --dport 143 -j ACCEPT
			-A FORWARD -p tcp -d $webIP --dport 443 -j ACCEPT
			-A FORWARD -p tcp -d $webIP --dport 80 -j ACCEPT
			-A FORWARD -p icmp --icmp-type 8 -j ACCEPT
			## allows established connections
			-A FORWARD -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
			## logs... something
			-A FORWARD -m limit --limit 5/min -j LOG --log-prefix "FART-OVERLOAD " --log-level 7
			:OUTPUT ACCEPT [0:0]
			COMMIT
			EOF
		"iptables-restore" /etc/iptables/rules.v4
	}
	####################
	#sending the selection forward
	####################
	printf " q|quit      =   Cancels the script                                     |\n"
	printf " 0|empty     =   Rules are cleared, everything is accepted              |\n"
	printf " 1|standard  =   SSH and Established Input. Drop the rest               |\n"
	printf " 2|atk       =   Only established Input                                 |\n"
	printf " 3|web       =   Allow ping, http(gross), and https                     |\n"
	printf " 4|mail      =   Allow pop, imap, smtp                                  |\n"
	printf " 5|router    =   Forward pop/imap/smtp/pings/http/https. Allow SSH/Ping |"
	printf "\n------------------------------------------------------------------------|\n"
	read -p "what kind of server are we?[standard]: " host
	: ${host:="standard"}    # setting the starting value to apply default settings

	case $host in
		q|quit)
			exit 1;;
		0|empty)
			empty;;
		1|standard)
			standard;;
		2|ATK|atk|attacker|attack)
			atk;;
		3|WEB|web|website)
			web;;
		4|MAIL|mail|email|e-mail)
			mail;;
		5|ROUTER|router)
			router;;
	esac
}

function summary(){
	printf "\n\n"
	printf "\n******************************************************************"
	printf "\nHopefully everything went as planned.. Here is the current iptable"
	printf "\n******************************************************************\n\n"
	printf "##### Mangle #####\n"
	iptables -L -n -t mangle
	printf "\n\n##### NAT #####\n"
	iptables -L -n -t nat
	printf "\n\n##### Standard #####\n"
	iptables -L -n
}
###########################################################################################
#are you root? no? well, try again later
###########################################################################################
function neo() {
	if [[ $EUID -ne 0  ]]; then
	echo "you forgot to run as root again... "
	echo "Current dir is "$(pwd)
	exit 1
	fi
}
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#+++++++++++++++++++++++++++++++++ FIGHT!! +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

main
