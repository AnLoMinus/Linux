### Debian ntp

sudo apt-get install ntp ntpdate -y
sudo systemctl start ntp
sudo systemctl enable ntp
sudo ntpdate -q 0.rhel.pool.ntp.org
sudo timedatectl set-timezone "America/New_York"
sudo systemctl restart ntp

### Debian auditd

sudo apt-get install auditd -y
sudo rm -rf /etc/audit/rules.d/audit.rules
sudo mv /root/config/audit.rules /etc/audit/rules.d/
sudo systemctl start auditd
sudo systemctl enable auditd

### Fail2Ban

sudo apt-get install fail2ban -y
sudo systemctl start fail2ban
sudo systemctl enable fail2ban

## Configure jail.conf
# "ignoreip" can be an IP address, a CIDR mask or a DNS host. Fail2ban will not
# ban a host which matches an address in this list. Several addresses can be
# defined using space separator.

#ignoreip = 127.0.0.1 192.168.1.0/24 8.8.8.8

# This will ignore connection coming from common private networks.
# Note that local connections can come from other than just 127.0.0.1, so
# this needs CIDR range too.
#ignoreip = 127.0.0.0/8 10.0.0.0/8 172.16.0.0/12 192.168.0.0/16

### Sending Logs

curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-6.5.4-amd64.deb
sudo dpkg -i filebeat-6.5.4-amd64.deb

cp /root/config/filebeat.yml /etc/filebeat/

filebeat setup --dashboards
service filebeat start
