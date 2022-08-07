## Debian Modsecurity Installation
#grep for warning
#disable rule host header is numeric IP address
#'Host header is a numeric IP address' id:920350
# In REQUEST-920

sudo apt-get install apache2 -y
sudo apt-get install libapache2-mod-security2 -y
sudo mkdir /etc/apache2/modsecurity.d
cd /etc/apache2/modsecurity.d
sudo git clone https://github.com/SpiderLabs/owasp-modsecurity-crs
cd owasp-modsecurity-crs
sudo mv crs-setup.conf.example crs-setup.conf
# Edit apache2.conf
# sudo vim apache2.conf
echo "<IfModule security2_module>
                Include modsecurity.d/owasp-modsecurity-crs/crs-setup.conf
                Include modsecurity.d/owasp-modsecurity-crs/rules/*.conf
    </IfModule>" >> /etc/apache2/apache2.conf
sudo mv /etc/modsecurity/modsecurity.conf-recommended /etc/modsecurity/modsecurity.conf
sudo sed -i "s/SecRuleEngine DetectionOnly/SecRuleEngine On/" /etc/modsecurity/modsecurity.conf
sudo systemctl restart apache2
# If Error journalctl -xe | less
