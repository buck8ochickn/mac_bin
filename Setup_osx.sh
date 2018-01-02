#untested










brew install clamav rkhunter vim htop
#configure clamav.conf.sample
sed -i -e 's/Example$/#Example/g' /usr/local/etc/clamav/clamd.conf.sample
sed -i -e 's/#LogFile\s\/tmp\/clamd.log/LogFile\s\/tmp\/clamd.log/g' /usr/local/etc/clamav/clamd.conf.sample
sed -i -e 's/Example$/#Example/g' /usr/local/etc/clamav/clamd.conf.sample
sed -i -e 's/Example$/#Example/g' /etc/clamav/freshclam.conf.smaple

cp /usr/local/etc/clamav/clamd.conf.sample /usr/local/etc/clamav/clamd.conf
cp /etc/clamav/freshclam.conf.sample /etc/clamav/freshclam.conf


#send mail needs configuring
#sudo vim /etc/postfix/main.cf
#http://www.developerfiles.com/how-to-send-emails-from-localhost-mac-os-x-el-capitan/

echo "relayhost = [smtp.gmail.com]:587" >>/etc/postfix/main.cf
echo "smtp_sasl_auth_enable = yes" >>/etc/postfix/main.cf
echo "smtp_sasl_mechanism_filter=plain"
echo "smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd" >>/etc/postfix/main.cf
echo "smtp_sasl_security_options = noanonymous" >>/etc/postfix/main.cf
echo "smtp_use_tls = yes" >>/etc/postfix/main.cf
echo "smtp_tls_security_level=encrypt" >>/etc/postfix/main.cf
#already in
#echo "tls_random_source=dev:/dev/urandom" >>/etc/postfix/main.cf


#
#
#
#Generate sasl_password if not already exists
#sudo vim /etc/postfix/sasl_passwd
#and enter in the following:-
#
#[smtp.gmail.com]:587 username@gmail.com:password



sudo chmod 600 /etc/postfix/sasl_passwd
sudo postmap /etc/postfix/sasl_passwd
sudo launchctl stop org.postfix.master
sudo launchctl start org.postfix.master

#
#tree /var/www/somefolder | mail -s "contents" your@yourdomain.com
#
#send test email

PidFile /var/run/clamd.pid
#configure clam and rk crons


#################################
#http://docs.hardentheworld.org/OS/MacOS_10.12_Sierra/#destroy-filevault-keys
#
#Hardening the OS

oshardening () {

echo "Now hardening the os" >> TEMP

echo "Set Destroy FileVault Keys (clears filevault keys from ram)">>

sudo pmset destroyfvkeyonstandby 1



}
