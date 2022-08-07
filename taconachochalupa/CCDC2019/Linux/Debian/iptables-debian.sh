### iptables configuration

### Save current iptables config and flush iptables

iptables-save > old-iptables.bk
#iptables-restore < iptables.bk
iptables -F

### Accept traffic for established sessions ?\
#Firewallcmd or iptables-persistent
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
#mirror this?

### Basic accept chain rules

## Incoming

iptables -A INPUT -p tcp --dport ssh -j ACCEPT
iptables -A INPUT -p tcp --dport http -j ACCEPT
iptables -A INPUT -p tcp --dport https -j ACCEPT
iptables -A INPUT -p tcp --dport http-alt -j ACCEPT

## Outgoing

iptables -A OUTPUT -p tcp --dport ssh -j ACCEPT
iptables -A OUTPUT -p tcp --dport http -j ACCEPT
iptables -A OUTPUT -p tcp --dport https -j ACCEPT
iptables -A OUTPUT -p tcp --dport http-alt -j ACCEPT

### Drop all packets that do not have rules

iptables -A INPUT -j DROP
#iptables -A OUTPUT -j DROP

### Block specific IP's

#iptables -A INPUT -s 202.54.20.22 -j DROP
#iptables -A OUTPUT -d 202.54.20.22 -j DROP

### Log Dropped Packets to Syslog

iptables -I INPUT 5 -m limit --limit 5/min -j LOG --log-prefix "iptables denied: " --log-level 7
iptables -I OUTPUT 5 -m limit --limit 5/min -j LOG --log-prefix "iptables denied: " --log-level 7

### Backup desired Configuration

iptables-save > new-iptables.bk
iptables-save > /etc/iptables/rules.v4

sudo apt-get install iptstate -y
sudo apt-get install iptables-persistent -y
sudo service netfilter-persistent start
