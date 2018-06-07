#untested
#
#
#
#
#
#Mac OSX 10.13
#

############################
#
#turn off rootless
#writen with help from
#https://www.howtogeek.com/230424/how-to-disable-system-integrity-protection-on-a-mac-and-why-you-shouldnt/

integrity() {

read -p "requires a reboot into recovery mode"


echo "creating a bash file to run located in ~/csrutil_status changer.sh"
read -p "please run after reboot in recovery mode"


#csrutil script
cat > ~/csrutil_status changer.sh << EOL

csrutil status
read -p "Are you sure you want to disable System Integrity Protection" sec_imput
if [[ "$sec_input" ==  y*  ||  "$sec_input" == Y*  ]] ; then
       echo " Aborting "
       exit 0
fi
csrutil disable

EOL
#/script


}





clamnhunter() {

brew install clamav rkhunter vim htop
#configure clamav.conf.sample
sed -i -e 's/Example$/#Example/g' /usr/local/etc/clamav/clamd.conf.sample
sed -i -e 's/#LogFile\s\/tmp\/clamd.log/LogFile\s\/tmp\/clamd.log/g' /usr/local/etc/clamav/clamd.conf.sample
sed -i -e 's/Example$/#Example/g' /usr/local/etc/clamav/clamd.conf.sample
sed -i -e 's/Example$/#Example/g' /etc/clamav/freshclam.conf.smaple

cp /usr/local/etc/clamav/clamd.conf.sample /usr/local/etc/clamav/clamd.conf
cp /etc/clamav/freshclam.conf.sample /etc/clamav/freshclam.conf

PidFile /var/run/clamd.pid
#configure clam and rk crons

}


mailsetup() {
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

}




#################################
#https://docs.hardentheworld.org/OS/MacOS_10.12_Sierra/#destroy-filevault-keys
#
#Hardening the OS

oshardening() {

echo "Now hardening the os" >> TEMP

echo "Set Destroy FileVault Keys (clears filevault keys from ram)">>

sudo pmset destroyfvkeyonstandby 1

echo "disabling the creation of metadatafiles" >> TEMP

defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true


#things needed to be done out side of the script

read -p "Please set your privacy setting nowSystem Preferences ⇒ Security & Privacy ⇒ Privacy"

read -p "Please disable system diagnostics : System Preferences ⇒ Security & Privacy ⇒ Privacy ⇒ Diagnostics & Usage ⇒ Un-check 'Send diagnostic & usage data to Apple'. Un-check 'Share crash data with app developers'."

read -p "Please disable the guest user: System Preferences ⇒ Users & Groups ⇒ Guest User ⇒ Un-check 'Allow guests to log in to this computer'."

read -p "Please disable handoff: System Preferences ⇒ General ⇒ Un-check 'Allow Handoff between this Mac and your iCloud devices'."

read -p "Please disable password hints: System Preferences ⇒ Users & Groups ⇒ Login Options ⇒ Un-check 'Show password hints'."

read -p "Please disable recent history: System Preferences ⇒ General ⇒ Set 'Recent items' to 'None'."

read -p "Please Disable Localization Services: System Preferences ⇒ Security & Privacy ⇒ Privacy ⇒ Location Services Select “System Services” and click 'Details...'. It is suggested to disable localization for all services, if not needed."

read -p "Please disable Spotlight: System Preferences ⇒ Spotlight Un-check 'Allow Spotlight Suggestions in Spotlight and Look Up'."
#needs rootless off 
sudo launchctl unload -w /System/Library/LaunchDaemons/com.apple.metadata.mds.plist






}









sec_exit() {
        less $TEMP
        echo "The script has finished running. The server will reboot in 1 minute. Notes have been saved to $TEMP in ~/Desktop/$TEMP"
        /sbin/shutdown -r 1
        #forced reboot, to make sure there are no hidden issues
exit;
}


read -p "please enable screen locking visit"

read -p "System Preferences > Security & Privacy and check the box for Require Password after. In the drop-down menu, you can set timing of the password to immediately"




##############################################
#
# How would you like to prepare your system


read -p 'Would you like to temporarly or perminantly disable System Integrity Protection (yes/no): ' sec_input;
if [[ "$sec_input" ==  y*  ||  "$sec_input" == Y*  ]] ; then
        sec_integrity='true'
fi




read -p 'Would you like to harden the OS (yes/no): ' sec_input;
if [[ "$sec_input" ==  y*  ||  "$sec_input" == Y*  ]] ; then
        sec_oshardening='true'
fi

read -p 'Would you like to install rkhunter and clamav (yes/no): ' sec_input;
if [[ "$sec_input" ==  y*  ||  "$sec_input" == Y*  ]] ; then
        sec_clamnhunter='true'
fi

######################################
# brew tools 
# ip command
brew install iproute2mac

######################################
#
# run the functions of the respective choices 
#


if sec_integrity = true ; then
integrity
fi

if sec_oshardening = true ; then
oshardening
fi

if sec_clamnhunter = true ; then
clamnhunter
fi

