#!/bin/bash 
#Installs Vulns.io 

#Install docker 
sudo apt install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
sudo apt update
sudo apt install docker-ce 

# sudo systemctl status docker 

#Install vuls 
sudo docker pull vuls/go-cve-dictionary
sudo docker pull vuls/goval-dictionary
sudo docker pull vuls/gost

# https://vuls.io/docs/en/tutorial-local-scan.html
# google tutorial for docker vuls 

#################################
#OpenVas 
sudo add-apt-repository ppa:mrazavi/openvas
sudo apt-get update -y
sudo apt-get install sqlite3 openvas9 -y
#hit yes 
sudo apt-get install texlive-latex-extra --no-install-recommends -y
sudo apt-get install texlive-fonts-recommended --no-install-recommends -y
sudo apt-get install libopenvas9-dev

sudo greenbone-nvt-sync 
sudo greenbone-scapdata-sync 
sudo greenbone-certdata-sync 

sudo systemctl restart openvas-scanner
sudo systemctl restart openvas-manager
sudo systemctl restart openvas-gsa
sudo openvasmd --rebuild --progress --verbose 

#check for install errors 
# sudo wget --no-check-certificate https://svn.wald.intevation.org/svn/openvas/branches/tools-attic/openvas-check-setup -P /usr/local/bin/
# sudo chmod +x /usr/local/bin/openvas-check-setup

# openvas-check-setup --v9






