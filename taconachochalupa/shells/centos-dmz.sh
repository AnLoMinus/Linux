#!/bin/bash

#centos is poc 
#must do: sudo vi /etc/yum.conf 
#hit 'i', on new line, add 'http_caching=packages', then hit 'esc' then :wq then enter

#compare security patches from clean centos install with the competition one  

#List upgradeable patches 
yum check-update

#check if there is update for service and patch it if there is one
#yum list mariadb
#yum install mariadb

#list past upgrades, saves to file 
rpm -qa

#list ALL local users, no jargon 
cut -d: -f1 /etc/passwd

#lists users that can login on the box
getent passwd | egrep -v '/s?bin/(nologin|shutdown|sync|halt)' | cut -d: -f1

#list system, weird users

#hardening
#Increase the delay time between login prompts (10sec)
sed -i "s/delay=[[:digit:]]\+/delay=10000000/" /etc/pam.d/login 

#file permissions 
# Set /etc/passwd ownership and access permissions.
chown root:root /etc/passwd
chmod 644 /etc/passwd

# Set /etc/shadow ownership and access permissions.
chown root:shadow /etc/shadow
chmod 640 /etc/shadow

# Set /etc/group ownership and access permissions.
chown root:root /etc/group
chmod 644 /etc/group

# Set /etc/gshadow ownership and access permissions.
chown root:shadow /etc/gshadow
chmod 640 /etc/group

# Set /etc/security/opasswd ownership and access permissions.
chown root:root /etc/security/opasswd
chmod 600 /etc/security/opasswd

# Set /etc/passwd- ownership and access permissions.
chown root:root /etc/passwd-
chmod 600 /etc/passwd-

# Set /etc/shadow- ownership and access permissions.
chown root:root /etc/shadow-
chmod 600 /etc/shadow-

# Set /etc/group- ownership and access permissions.
chown root:root /etc/group-
chmod 600 /etc/group-

# Set /etc/gshadow- ownership and access permissions.
chown root:root /etc/gshadow-
chmod 600 /etc/gshadow-

#banner restrictions 
chown root:root /etc/motd
chmod 644 /etc/motd
echo "Authorized uses only. All activity may be monitored and reported." > /etc/motd
  
chown root:root /etc/issue
chmod 644 /etc/issue
echo "Authorized uses only. All activity may be monitored and reported." > /etc/issue
  
chown root:root /etc/issue.net
chmod 644 /etc/issue.net
echo "Authorized uses only. All activity may be monitored and reported." > /etc/issue.net

sys_upgrades() {
	#This might actually take too long
	    yum -y update
	    yum -y upgrade
		yum -y autoremove
	    }

permission_narrowing() {
	    chmod 700 /root
	    chmod 700 /var/log/audit
		chmod 740 /etc/sysconfig/iptables-config
		chmod 740 /etc/sysconfig/firewalld
		chmod 740 /sbin/iptables
		chmod 700 /etc/skel
		chmod 600 /etc/rsyslog.conf
		chmod 640 /etc/security/access.conf
		chmod 600 /etc/sysctl.conf
				}

disable_postfix() {
		systemctl stop postfix
		systemctl disable postfix
	}

##### Delete this line
kernel_tuning() {
    sysctl kernel.randomize_va_space=1
    
    # Enable IP spoofing protection
    sysctl net.ipv4.conf.all.rp_filter=1

    # Disable IP source routing
    sysctl net.ipv4.conf.all.accept_source_route=0
    
    # Ignoring broadcasts request
    sysctl net.ipv4.icmp_echo_ignore_broadcasts=1
    sysctl net.ipv4.icmp_ignore_bogus_error_messages=1
    
    # Make sure spoofed packets get logged
    sysctl net.ipv4.conf.all.log_martians=1
    sysctl net.ipv4.conf.default.log_martians=1

    # Disable ICMP routing redirects
    sysctl -w net.ipv4.conf.all.accept_redirects=0
    sysctl -w net.ipv6.conf.all.accept_redirects=0
    sysctl -w net.ipv4.conf.all.send_redirects=0
    sysctl -w net.ipv6.conf.all.send_redirects=0

    # Disables the magic-sysrq key
    sysctl kernel.sysrq=0
    
    # Turn off the tcp_timestamps
    sysctl net.ipv4.tcp_timestamps=0

    # Enable TCP SYN Cookie Protection
    sysctl net.ipv4.tcp_syncookies=1

    # Enable bad error message Protection
    sysctl net.ipv4.icmp_ignore_bogus_error_responses=1
    
    # RELOAD WITH NEW SETTINGS
    sysctl -p
}

disable_ipv6() {
    sysctl -w net.ipv6.conf.default.disable_ipv6=1
    sysctl -w net.ipv6.conf.all.disable_ipv6=1
}

main() {
	    sys_upgrades
		permission_narrowing
		disable_postfix
		kernel_tuning
		disable_ipv6
	}

main "$@"