#!/bin/bash

source helpers.sh

# Installing Dependencies
# Needed Prerequesites will be set up here
install_dep(){
   clear
   f_banner
   echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
   echo -e "\e[93m[+]\e[00m Setting some Prerequisites"
   echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
   echo ""
   spinner
   add-apt-repository universe
   say_done
}
##############################################################################################################

# Setting a more restrictive UMASK
restrictive_umask(){
   clear
   f_banner
   echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
   echo -e "\e[93m[+]\e[00m Setting UMASK to a more Restrictive Value (027)"
   echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
   echo ""
   spinner
   cp templates/login.defs /etc/login.defs
   # sed -i s/umask\ 022/umask\ 027/g /etc/init.d/rc
   echo ""
   echo "OK"
   say_done
}

##############################################################################################################

#Securing /tmp Folder
secure_tmp(){
  clear
  f_banner
  echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
  echo -e "\e[93m[+]\e[00m Securing /tmp Folder"
  echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
  echo ""
  echo -n " ¿Did you Create a Separate /tmp partition during the Initial Installation? (y/n): "; read tmp_answer
  if [ "$tmp_answer" == "n" ]; then
      echo "We will create a FileSystem for the /tmp Directory and set Proper Permissions "
      spinner
      dd if=/dev/zero of=/usr/tmpDISK bs=1024 count=2048000
      mkdir /tmpbackup
      cp -Rpf /tmp /tmpbackup
      mount -t tmpfs -o loop,noexec,nosuid,rw /usr/tmpDISK /tmp
      chmod 1777 /tmp
      cp -Rpf /tmpbackup/* /tmp/
      rm -rf /tmpbackup
      echo "/usr/tmpDISK  /tmp    tmpfs   loop,nosuid,nodev,noexec,rw  0 0" >> /etc/fstab
      sudo mount -o remount /tmp
      say_done
  else
      echo "Nice Going, Remember to set proper permissions in /etc/fstab"
      echo ""
      echo "Example:"
      echo ""
      echo "/dev/sda4   /tmp   tmpfs  loop,nosuid,noexec,rw  0 0 "
      say_done
  fi
}

##############################################################################################################

# Secure SSH
secure_ssh(){
    clear
    f_banner
    echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
    echo -e "\e[93m[+]\e[00m Securing SSH"
    echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
    echo ""
    echo -n " Securing SSH..."
    spinner
    sed s/USERNAME/$username/g templates/sshd_config > /etc/ssh/sshd_config; echo "OK"
    chattr -i /home/$username/.ssh/authorized_keys
    service ssh restart
    say_done
}

##############################################################################################################

# Set IPTABLES Rules
set_iptables(){
    clear
    f_banner
    echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
    echo -e "\e[93m[+]\e[00m Setting IPTABLE RULES"
    echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
    echo ""
    echo -n " Setting Iptables Rules..."
    spinner
    sh templates/iptables.sh
    cp templates/iptables.sh /etc/init.d/
    chmod +x /etc/init.d/iptables.sh
    ln -s /etc/init.d/iptables.sh /etc/rc2.d/S99iptables.sh
    say_done
}

##############################################################################################################

# Install fail2ban
    # To Remove a Fail2Ban rule use:
    # iptables -D fail2ban-ssh -s IP -j DROP
install_fail2ban(){
    clear
    f_banner
    echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
    echo -e "\e[93m[+]\e[00m Installing Fail2Ban"
    echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
    echo ""
    apt install sendmail
    apt install fail2ban
    say_done
}

##############################################################################################################

# Install, Configure and Optimize MySQL
install_secure_mysql(){
    clear
    f_banner
    echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
    echo -e "\e[93m[+]\e[00m Installing, Configuring and Optimizing MySQL"
    echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
    echo ""
    apt install mysql-server
    echo ""
    echo -n " configuring MySQL............ "
    spinner
    cp templates/mysql /etc/mysql/mysqld.cnf; echo " OK"
    mysql_secure_installation
    cp templates/usr.sbin.mysqld /etc/apparmor.d/local/usr.sbin.mysqld
    service mysql restart
    say_done
}

##############################################################################################################

# Install Apache
install_apache(){
  clear
  f_banner
  echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
  echo -e "\e[93m[+]\e[00m Installing Apache Web Server"
  echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
  echo ""
  apt install apache2
  say_done
}

##############################################################################################################

# Install Nginx With ModSecurity
install_nginx_modsecurity(){
  clear
  f_banner
  echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
  echo -e "\e[93m[+]\e[00m Downloading and Compiling Nginx with ModSecurity"
  echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
  echo ""
  apt -y install git build-essential libpcre3 libpcre3-dev libssl-dev libtool autoconf apache2-prefork-dev libxml2-dev libcurl4-openssl-dev
  mkdir src
  cd src/
  git clone https://github.com/SpiderLabs/ModSecurity
  cd ModSecurity
  ./autogen.sh
  ./configure --enable-standalone-module
  make
  cd ..
  wget http://nginx.org/download/nginx-1.9.7.tar.gz
  tar xzvf nginx-1.9.7.tar.gz
  cp ../templates/ngx_http_header_filter_module.c nginx-1.9.7/src/http/ngx_http_header_filter_module.c
  cd nginx-1.9.7/
  ./configure --user=www-data --group=www-data --with-pcre-jit --with-debug --with-http_ssl_module --add-module=/root/JShielder/UbuntuServer_14.04LTS/src/ModSecurity/nginx/modsecurity
  make
  make install
  #Replacing Nginx conf with secure Configurations
  cp ../../templates/nginx /usr/local/nginx/conf/nginx.conf
  #Jason Giedymin Nginx Init Script
  wget https://raw.github.com/JasonGiedymin/nginx-init-ubuntu/master/nginx -O /etc/init.d/nginx
  chmod +x /etc/init.d/nginx
  update-rc.d nginx defaults
  mkdir /usr/local/nginx/conf/sites-available
  mkdir /usr/local/nginx/conf/sites-enabled
  say_done
}
##############################################################################################################

#Set Nginx Modsecurity OWASP Rules
set_nginx_modsec_OwaspRules(){
  clear
  f_banner
  echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
  echo -e "\e[93m[+]\e[00m Setting OWASP Rules for ModSecurity on Nginx"
  echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
  echo ""
  cd src/
  wget https://github.com/SpiderLabs/owasp-modsecurity-crs/tarball/master -O owasp.tar.gz
  tar -zxvf owasp.tar.gz
  owaspdir=$(ls -la | grep SpiderLabs | cut -d ' ' -f18)
  cp ModSecurity/modsecurity.conf-recommended /usr/local/nginx/conf/modsecurity.conf
  cp ModSecurity/unicode.mapping /usr/local/nginx/conf/
  cd $owaspdir/
  cat modsecurity_crs_10_setup.conf.example >> /usr/local/nginx/conf/modsecurity.conf
  cd base_rules/
  cat *.conf >> /usr/local/nginx/conf/modsecurity.conf
  cp *.data /usr/local/nginx/conf/
  cd ../../..
  service nginx restart
  say_done
}

##############################################################################################################

# Install, Configure and Optimize PHP
install_secure_php(){
    clear
    f_banner
    echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
    echo -e "\e[93m[+]\e[00m Installing, Configuring and Optimizing PHP"
    echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
    echo ""
    apt install -y php php-cli php-pear
    apt install -y php-mysql python-mysqldb libapache2-mod-php7.2
    echo ""
    echo -n " Replacing php.ini..."
    spinner
    cp templates/php /etc/php/7.2/apache2/php.ini; echo " OK"
    cp templates/php /etc/php/7.2/cli/php.ini; echo " OK"
    service apache2 restart
    say_done
}

##############################################################################################################
# Install, Configure and Optimize PHP for Nginx
install_php_nginx(){
  clear
  f_banner
  echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
  echo -e "\e[93m[+]\e[00m Installing, Configuring and Optimizing PHP/PHP-FPM"
  echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
  echo ""
  apt install php-fpm php php-cli php-pear
  apt install php-mysql python-mysqldb
  echo ""
  echo -n " Replacing php.ini..."
  spinner
  cp templates/php /etc/php/7.0/cli/php.ini; echo " OK"
  cp templates/phpnginx /etc/php/7.0/fpm/php.ini; echo "OK"
  service php-fpm restart
  service nginx restart
  say_done
}

##############################################################################################################

# Install ModSecurity
install_modsecurity(){
    clear
    f_banner
    echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
    echo -e "\e[93m[+]\e[00m Installing ModSecurity"
    echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
    echo ""
    apt install libxml2 libxml2-dev libxml2-utils
    apt install libaprutil1 libaprutil1-dev
    apt install libapache2-mod-security2
    service apache2 restart
    say_done
}

##############################################################################################################

# Configure OWASP for ModSecurity
set_owasp_rules(){
    clear
    f_banner
    echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
    echo -e "\e[93m[+]\e[00m Setting UP OWASP Rules for ModSecurity"
    echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
    echo ""

    #for archivo in /usr/share/modsecurity-crs/base_rules/*
     #   do ln -s $archivo /usr/share/modsecurity-crs/activated_rules/
    #done

    #for archivo in /usr/share/modsecurity-crs/optional_rules/*
    #    do ln -s $archivo /usr/share/modsecurity-crs/activated_rules/
    #done
    spinner
    echo "OK"

    sed s/SecRuleEngine\ DetectionOnly/SecRuleEngine\ On/g /etc/modsecurity/modsecurity.conf-recommended > salida
    mv salida /etc/modsecurity/modsecurity.conf

    echo 'SecServerSignature "AntiChino Server 1.0.4 LS"' >> /usr/share/modsecurity-crs/modsecurity_crs_10_setup.conf
    echo 'Header set X-Powered-By "Plankalkül 1.0"' >> /usr/share/modsecurity-crs/modsecurity_crs_10_setup.conf
    echo 'Header set X-Mamma "Mama mia let me go"' >> /usr/share/modsecurity-crs/modsecurity_crs_10_setup.conf

    a2enmod headers
    service apache2 restart
    say_done
}

##############################################################################################################

# Configure and optimize Apache
secure_optimize_apache(){
    clear
    f_banner
    echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
    echo -e "\e[93m[+]\e[00m Optimizing Apache"
    echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
    echo ""
    cp templates/apache /etc/apache2/apache2.conf
    echo " -- Enabling ModRewrite"
    spinner
    a2enmod rewrite
    service apache2 restart
    say_done
}

##############################################################################################################

# Install ModEvasive
install_modevasive(){
    clear
    f_banner
    echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
    echo -e "\e[93m[+]\e[00m Installing ModEvasive"
    echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
    echo ""
    echo -n " Type Email to Receive Alerts "; read inbox
    apt install libapache2-mod-evasive
    mkdir /var/log/mod_evasive
    chown www-data:www-data /var/log/mod_evasive/
    sed s/MAILTO/$inbox/g templates/mod-evasive > /etc/apache2/mods-available/mod-evasive.conf
    service apache2 restart
    say_done
}

##############################################################################################################

# Install Mod_qos/spamhaus
install_qos_spamhaus(){
    clear
    f_banner
    echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
    echo -e "\e[93m[+]\e[00m Installing Mod_Qos/Spamhaus"
    echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
    echo ""
    apt -y install libapache2-mod-qos
    cp templates/qos /etc/apache2/mods-available/qos.conf
    apt -y install libapache2-mod-spamhaus
    cp templates/spamhaus /etc/apache2/mods-available/spamhaus.conf
    service apache2 restart
    say_done
}

##############################################################################################################

# Install Additional Packages
additional_packages(){
    clear
    f_banner
    echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
    echo -e "\e[93m[+]\e[00m Installing Additional Packages"
    echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
    echo ""
    echo "Install tree............."; apt install tree
    echo "Install Python-MySQLdb..."; apt install python-mysqldb
    echo "Install WSGI............."; apt install libapache2-mod-wsgi
    echo "Install pear............."; apt install php-pear
    echo "Install DebSums.........."; apt install debsums
    echo "Install apt-show-versions"; apt install apt-show-versions
    echo "Install PHPUnit..........";
    pear config-set auto_discover 1
    mv phpunit-patched /usr/share/phpunit
    echo include_path = ".:/usr/share/phpunit:/usr/share/phpunit/PHPUnit" >> /etc/php/7.2/cli/php.ini
    echo include_path = ".:/usr/share/phpunit:/usr/share/phpunit/PHPUnit" >> /etc/php/7.2/apache2/php.ini
    service apache2 restart
    say_done
}

##############################################################################################################

# Tune and Secure Kernel
tune_secure_kernel(){
    clear
    f_banner
    echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
    echo -e "\e[93m[+]\e[00m Tuning and Securing the Linux Kernel"
    echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
    echo ""
    echo " Securing Linux Kernel"
    spinner
    echo "* hard core 0" >> /etc/security/limits.conf
    cp templates/sysctl.conf /etc/sysctl.conf; echo " OK"
    cp templates/ufw /etc/default/ufw
    sysctl -e -p
    say_done
}

##############################################################################################################

# Tuning
tune_nano_vim_bashrc(){
    clear
    f_banner
    echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
    echo -e "\e[93m[+]\e[00m Tunning bashrc, nano and Vim"
    echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
    echo ""

# Tune .bashrc
    echo "Tunning .bashrc......"
    spinner
    cp templates/bashrc-root /root/.bashrc
    cp templates/bashrc-user /home/$username/.bashrc
    chown $username:$username /home/$username/.bashrc
    echo "OK"


# Tune Vim
    echo "Tunning Vim......"
    spinner
    tunning vimrc
    echo "OK"

# Tune Nano
    echo "Tunning Nano......"
    spinner
    tunning nanorc
    echo "OK"
    say_done
}

##############################################################################################################

# Install PortSentry
install_portsentry(){
    clear
    f_banner
    echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
    echo -e "\e[93m[+]\e[00m Installing PortSentry"
    echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
    echo ""
    apt install portsentry
    mv /etc/portsentry/portsentry.conf /etc/portsentry/portsentry.conf-original
    cp templates/portsentry /etc/portsentry/portsentry.conf
    sed s/tcp/atcp/g /etc/default/portsentry > salida.tmp
    mv salida.tmp /etc/default/portsentry
    /etc/init.d/portsentry restart
    say_done
}

##############################################################################################################

# Install and Configure Artillery
install_artillery (){
    clear
    f_banner
    echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
    echo -e "\e[93m[+]\e[00m Cloning Repo and Installing Artillery"
    echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
    echo ""
    git clone https://github.com/BinaryDefense/artillery
    cd artillery/
    python setup.py
    cd ..
    echo ""
    echo "Setting Iptable rules for artillery"
    spinner
    for port in 22 1433 8080 21 5900 53 110 1723 1337 10000 5800 44443 16993; do
      echo "iptables -A INPUT -p tcp -m tcp --dport $port -j ACCEPT" >> /etc/init.d/iptables.sh
    done
    echo ""
    echo "Artillery configuration file is /var/artillery/config"
    say_done  
}
##############################################################################################################

# Additional Hardening Steps
additional_hardening(){
    clear
    f_banner
    echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
    echo -e "\e[93m[+]\e[00m Running additional Hardening Steps"
    echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
    echo ""
    echo "Running Additional Hardening Steps...."
    spinner
    echo tty1 > /etc/securetty
    chmod 0600 /etc/securetty
    chmod 700 /root
    chmod 600 /boot/grub/grub.cfg
    #Remove AT and Restrict Cron
    apt purge at
    apt install -y libpam-cracklib
    echo ""
    echo " Securing Cron "
    spinner
    touch /etc/cron.allow
    chmod 600 /etc/cron.allow
    awk -F: '{print $1}' /etc/passwd | grep -v root > /etc/cron.deny
    echo ""
    echo -n " Do you want to Disable USB Support for this Server? (y/n): " ; read usb_answer
    if [ "$usb_answer" == "y" ]; then
       echo ""
       echo "Disabling USB Support"
       spinner
       echo "blacklist usb-storage" | sudo tee -a /etc/modprobe.d/blacklist.conf
       update-initramfs -u
       echo "OK"
       say_done
    else
       echo "OK"
       say_done
    fi
}

##############################################################################################################

# Install Unhide
install_unhide(){
    clear
    f_banner
    echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
    echo -e "\e[93m[+]\e[00m Installing UnHide"
    echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
    echo ""
    echo "Unhide is a forensic tool to find hidden processes and TCP/UDP ports by rootkits / LKMs or by another hidden technique."
    sleep 1
    apt -y install unhide
    echo ""
    echo " Unhide is a tool for Detecting Hidden Processes "
    echo " For more info about the Tool use the manpages "
    echo " man unhide "
    say_done
}

##############################################################################################################

# Install Tiger
#Tiger is and Auditing and Intrusion Detection System
install_tiger(){
    clear
    f_banner
    echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
    echo -e "\e[93m[+]\e[00m Installing Tiger"
    echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
    echo ""
    echo "Tiger is a security tool that can be use both as a security audit and intrusion detection system"
    sleep 1
    apt -y install tiger
    echo ""
    echo " For More info about the Tool use the ManPages "
    echo " man tiger "
    say_done
}

##############################################################################################################

#Install PSAD
#PSAD actively monitors firewall logs to determine if a scan or attack is taking place
install_psad(){
clear
f_banner
echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
echo -e "\e[93m[+]\e[00m Install PSAD"
echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
echo " PSAD is a piece of Software that actively monitors you Firewall Logs to Determine if a scan
       or attack event is in Progress. It can alert and Take action to deter the Threat
       NOTE:
       IF YOU ARE ONLY RUNNING THIS FUNCTION, YOU MUST ENABLE LOGGING FOR iptables
       iptables -A INPUT -j LOG
       iptables -A FORWARD -j LOG
       "
echo ""
echo -n " Do you want to install PSAD (Recommended)? (y/n): " ; read psad_answer
if [ "$psad_answer" == "y" ]; then
     echo -n " Type an Email Address to Receive PSAD Alerts: " ; read inbox1
     apt install psad
     sed -i s/INBOX/$inbox1/g templates/psad.conf
     sed -i s/CHANGEME/$host_name.$domain_name/g templates/psad.conf  
     cp templates/psad.conf /etc/psad/psad.conf
     psad --sig-update
     service psad restart
     echo "Installation and Configuration Complete"
     echo "Run service psad status, for detected events"
     echo ""
     say_done
else
     echo "OK"
     say_done
fi
}

############################################################################################################
# Restrict Access to Apache Config Files
apache_conf_restrictions(){
    clear
    f_banner
    echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
    echo -e "\e[93m[+]\e[00m Restricting Access to Apache Config Files"
    echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
    echo ""
    echo " Restricting Access to Apache Config Files......"
    spinner
     chmod 750 /etc/apache2/conf* >/dev/null 2>&1
     chmod 511 /usr/sbin/apache2 >/dev/null 2>&1
     chmod 750 /var/log/apache2/ >/dev/null 2>&1
     chmod 640 /etc/apache2/conf-available/* >/dev/null 2>&1
     chmod 640 /etc/apache2/conf-enabled/* >/dev/null 2>&1
     chmod 640 /etc/apache2/apache2.conf >/dev/null 2>&1
     echo " OK"
     say_done
}

##############################################################################################################

# Additional Security Configurations
  #Enable Unattended Security Updates
  unattended_upgrades(){
  clear
  f_banner
  echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
  echo -e "\e[93m[+]\e[00m Enable Unattended Security Updates"
  echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
  echo ""
  echo -n " ¿Do you Wish to Enable Unattended Security Updates? (y/n): "; read unattended
  if [ "$unattended" == "y" ]; then
      dpkg-reconfigure -plow unattended-upgrades
  else
      clear
  fi
}

##############################################################################################################

# Enable Process Accounting
enable_proc_acct(){
  clear
  f_banner
  echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
  echo -e "\e[93m[+]\e[00m Enable Process Accounting"
  echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
  echo ""
  apt install acct
  touch /var/log/wtmp
  echo "OK"
}

#Install and enable auditd

install_auditd(){
  clear
  f_banner
  echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
  echo -e "\e[93m[+]\e[00m Installing auditd"
  echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
  echo ""
  apt install auditd

  # Using CIS Benchmark configuration
  
  #Ensure auditing for processes that start prior to auditd is enabled 
  echo ""
  echo "Enabling auditing for processes that start prior to auditd"
  spinner
  sed -i 's/GRUB_CMDLINE_LINUX=""/GRUB_CMDLINE_LINUX="audit=1"/g' /etc/default/grub
  update-grub

  echo ""
  echo "Configuring Auditd Rules"
  spinner

  cp templates/audit-CIS.rules /etc/audit/rules.d/audit.rules

  find / -xdev \( -perm -4000 -o -perm -2000 \) -type f | awk '{print \
  "-a always,exit -F path=" $1 " -F perm=x -F auid>=1000 -F auid!=4294967295 \
  -k privileged" } ' >> /etc/audit/rules.d/audit.rules

  echo " " >> /etc/audit/rules.d/audit.rules
  echo "#End of Audit Rules" >> /etc/audit/rules.d/audit.rules
  echo "-e 2" >>/etc/audit/rules.d/audit.rules

  systemctl enable auditd.service
  service auditd restart
  echo "OK"
  say_done
}
##############################################################################################################

#Install and Enable sysstat

install_sysstat(){
  clear
  f_banner
  echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
  echo -e "\e[93m[+]\e[00m Installing and enabling sysstat"
  echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
  echo ""
  apt install sysstat
  sed -i 's/ENABLED="false"/ENABLED="true"/g' /etc/default/sysstat
  service sysstat start
  echo "OK"
  say_done
}

##############################################################################################################

#Install ArpWatch

install_arpwatch(){
  clear
  f_banner
  echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
  echo -e "\e[93m[+]\e[00m ArpWatch Install"
  echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
  echo ""
  echo "ArpWatch is a tool for monitoring ARP traffic on System. It generates log of observed pairing of IP and MAC."
  echo ""
  echo -n " Do you want to Install ArpWatch on this Server? (y/n): " ; read arp_answer
  if [ "$arp_answer" == "y" ]; then
     echo "Installing ArpWatch"
     spinner
     apt install -y arpwatch
     systemctl enable arpwatch.service
     service arpwatch start
     echo "OK"
     say_done
  else
     echo "OK"
     say_done
  fi
}

##############################################################################################################

set_grubpassword(){
  clear
  f_banner
  echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
  echo -e "\e[93m[+]\e[00m GRUB Bootloader Password"
  echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
  echo ""
  echo "It is recommended to set a password on GRUB bootloader to prevent altering boot configuration (e.g. boot in single user mode without password)"
  echo ""
  echo -n " Do you want to set a GRUB Bootloader Password? (y/n): " ; read grub_answer
  if [ "$grub_answer" == "y" ]; then
    grub-mkpasswd-pbkdf2 | tee grubpassword.tmp
    grubpassword=$(cat grubpassword.tmp | sed -e '1,2d' | cut -d ' ' -f7)
    echo " set superusers="root" " >> /etc/grub.d/40_custom
    echo " password_pbkdf2 root $grubpassword " >> /etc/grub.d/40_custom
    rm grubpassword.tmp
    update-grub
    echo "On every boot enter root user and the password you just set"
    echo "OK"
    say_done
  else
    echo "OK"
    say_done
  fi

echo -e ""
echo -e "Securing Boot Settings"
spinner
sleep 2
chown root:root /boot/grub/grub.cfg
chmod og-rwx /boot/grub/grub.cfg
say_done

}    

##############################################################################################################

# Reboot Server
reboot_server(){
    clear
    f_banner
    echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
    echo -e "\e[93m[+]\e[00m Final Step"
    echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
    echo ""
    sed -i s/USERNAME/$username/g templates/texts/bye
    sed -i s/SERVERIP/$serverip/g templates/texts/bye
    cat templates/texts/bye
    echo -n " ¿Were you able to connect via SSH to the Server using $username? (y/n): "; read answer
    if [ "$answer" == "y" ]; then
        reboot
    else
        echo "Server will not Reboot"
        echo "Bye."
    fi
}

##################################################################################################################

clear
f_banner
echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
echo -e "\e[93m[+]\e[00m SELECT THE DESIRED OPTION"
echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
echo ""
echo "1. LAMP Deployment"
echo "2. Reverse Proxy Deployment With Apache"
echo "3. LEMP Deployment (Under Development, Testing)"
echo "4. Reverse Proxy Deployment with Nginx (ModSecurity)"
echo "5. Running With SecureWPDeployer or JSDeployer Script"
echo "6. Customized Run (Only run desired Options)"
echo "7. CIS Benchmark Hardening"
echo "8. Exit"
echo

read choice

case $choice in

1)
check_root
install_dep
config_host
config_timezone
update_system
restrictive_umask
unused_filesystems
uncommon_netprotocols
admin_user
rsa_keygen
rsa_keycopy
secure_ssh
set_iptables
install_fail2ban
install_secure_mysql
install_apache
install_secure_php
install_modsecurity
set_owasp_rules
secure_optimize_apache
install_modevasive
install_qos_spamhaus
config_fail2ban
additional_packages
tune_secure_kernel
install_rootkit_hunter
tune_nano_vim_bashrc
daily_update_cronjob
install_artillery
additional_hardening
install_unhide
install_tiger
install_psad
disable_compilers
secure_tmp
apache_conf_restrictions
unattended_upgrades
enable_proc_acct
install_auditd
install_sysstat
install_arpwatch
set_grubpassword
file_permissions
reboot_server
;;

6)

menu=""
until [ "$menu" = "34" ]; do

clear
read menu
case $menu in

1)
config_host
;;

2)
config_timezone
;;

3)
update_system
;;

4)
admin_user
;;

5)
rsa_keygen
rsa_keycopy
;;

6)
echo "key Pair must be created "
echo "What user will have access via SSH? " ; read username
rsa_keygen
rsa_keycopy
secure_ssh
;;

7)
set_iptables
;;

8)
echo "Type Email to receive Alerts: " ; read inbox
install_fail2ban
config_fail2ban
;;

9)
install_apache
secure_optimize_apache
apache_conf_restrictions
;;

10)
install_nginx_modsecurity
set_nginx_modsec_OwaspRules
;;

11)
set_nginx_vhost
;;


12)
set_nginx_vhost_nophp
;;

13)
install_secure_php
;;

14)
install_php_nginx
;;

15)
install_modsecurity
set_owasp_rules
;;

16)
install_modevasive
;;

17)
install_qos_spamhaus
;;

18)
tune_secure_kernel
;;

19)
install_rootkit_hunter
;;

20)
tune_nano_vim_bashrc
;;

21)
install_portsentry
;;

22)
additional_hardening
;;

23)
install_unhide
;;

24)
install_tiger
;;

25)
disable_compilers;
;;

26)
unattended_upgrades
;;

27)
enable_proc_acct
;;

#28)
#install_phpsuhosin
#;;

29)
install_secure_mysql
;;

30)
restrictive_umask
;;

31)
secure_tmp
;;

32)
install_psad
;;

33)
set_grubpassword
;;

34)
break ;;

*) ;;

esac
done
;;

7)
chmod +x jshielder-CIS.sh
./jshielder-CIS.sh
;;

8)
exit 0
;;

esac
##############################################################################################################
