#implement this script so it runs over and over again, places output somewhere 
sudo nmap -sP 172.16.1.0/24 -oX mapper.xml && sudo xsltproc  mapper.xml -o mapper.html 

#README  https://www.cyberciti.biz/faq/how-do-i-add-jobs-to-cron-under-linux-or-unix-oses/
