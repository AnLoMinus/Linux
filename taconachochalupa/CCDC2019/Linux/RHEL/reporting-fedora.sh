### Fedora ntp

sudo yum install ntp ntpdate -y
sudo systemctl start ntpd
sudo systemctl enable ntpd
sudo ntpdate -q 0.rhel.pool.ntp.org
sudo timedatectl set-timezone "America/New_York"
sudo systemctl restart ntpd

### Fedora auditd

sudo yum install audit -y
sudo rm -rf /etc/audit/rules.d/audit.rules
sudo mv audit.rules /etc/audit/rules.d/
sudo systemctl start auditd
sudo systemctl enable auditd

### Fail2Ban

sudo yum install fail2ban -y
sudo systemctl start fail2ban
sudo systemctl enable fail2ban

### Sending Logs

curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-6.5.4-x86_64.rpm
sudo rpm -vi filebeat-6.5.4-x86_64.rpm

cp filebeat.yml /etc/filebeat/

filebeat setup --dashboards
service filebeat start
