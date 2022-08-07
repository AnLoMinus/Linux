user=root
host=10.0.1.172
me=192.168.1.190:8000

### cd /Users/Alfonzo/Desktop/CCDC
### tar -zcvf configs.tar.gz config
### python -m SimpleHTTPServer
### curl 192.168.1.190:8080/
## ssh -t rootuser@host 'wget myIP:port/CCDC2019/Linux/configs.tar.gz'

### Setting up

# Adding key to host
ssh-copy-id ${user}@${host}

# Moving configs over
ssh -t ${user}@${host} "wget ${me}/CCDC2019/Linux/configs.tar.gz"
# Unzipping configs file
ssh -t ${user}@${host} 'tar -xzvf configs.tar.gz'

### Running scripts

# Running Startup script
ssh -t ${user}@${host} "curl ${me}/CCDC2019/Linux/Debian/start-debian.sh | /bin/bash"

# Running Reporting script
ssh -t ${user}@${host} "curl ${me}/CCDC2019/Linux/Debian/reporting-debian.sh | /bin/bash"

# Moving other scripts over to the machine

ssh -t ${user}@${host} "wget ${me}/CCDC2019/Linux/Debain/iptables-debian.sh"
ssh -t ${user}@${host} "wget ${me}/CCDC2019/Linux/Debain/configs-debian.sh"
ssh -t ${user}@${host} "wget ${me}/CCDC2019/Linux/Debain/modsecurity-debian.sh"
ssh -t ${user}@${host} "wget ${me}/CCDC2019/Linux/Debain/apparmor-debian.sh"

### Cleaning up

## Copying files back
mkdir /Users/Alfonzo/Desktop/CCDC/CCDC2019/Linux/hostinfo/${host}
scp ${user}@${host}:bash.bk /Users/Alfonzo/Desktop/CCDC/CCDC2019/Linux/hostinfo/${host}
scp ${user}@${host}:version.txt /Users/Alfonzo/Desktop/CCDC/CCDC2019/Linux/hostinfo/${host}
scp ${user}@${host}:sudo.bk /Users/Alfonzo/Desktop/CCDC/CCDC2019/Linux/hostinfo/${host}

## Removing files

ssh -t ${user}@${host} 'rm bash.bk'
ssh -t ${user}@${host} 'rm version.txt'
ssh -t ${user}@${host} 'rm sudo.bk'
