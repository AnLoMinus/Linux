### Fedora ModSecurity

sudo yum install mod_security mod_security_crs -y
sudo sed -i "s/SecRuleEngine DetectionOnly/SecRuleEngine On/" /etc/httpd/conf.d/mod_security.conf
sudo service httpd restart

sudo mkdir /etc/httpd/modsecurity.d
cd /etc/httpd/modsecurity.d
sudo git clone https://github.com/SpiderLabs/owasp-modsecurity-crs
sudo mv owasp-modsecurity-crs/crs-setup.conf.example owasp-modsecurity-crs/crs-setup.conf
echo "<IfModule security2_module>
                Include modsecurity.d/owasp-modsecurity-crs/crs-setup.conf
                Include modsecurity.d/owasp-modsecurity-crs/rules/*.conf
    </IfModule>" >> /etc/httpd/conf/httpd.conf
sudo service httpd restart
