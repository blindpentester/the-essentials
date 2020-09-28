#!/bin/bash
#
# Simple script to reach out and get some toys for Kali Linux 2020.X to help collect recon/bug bounty/fuzzing tools
#
#
# Usage: 
# sudo chmod +x the_essentials.sh
# sudo ./the_essentials.sh

red=$'\e[1;31m'
grn=$'\e[1;32m'
blu=$'\e[1;34m'
mag=$'\e[1;35m'
cyn=$'\e[1;36m'
white=$'\e[0m'

if [ "$EUID" -ne 0 ]
	then echo -e $grn"\n\n Script must be run with sudo ./the_essentials.sh or as root \n"$white
       exit
fi

fix_sources() {
	echo $grn"Fixing sources..."$white
	echo "deb http://http.kali.org/kali kali-rolling main non-free contrib" > /etc/apt/sources.list
	echo "deb-src http://http.kali.org/kali kali-rolling main non-free contrib" >> /etc/apt/sources.list
	sudo apt update >/dev/null 2>&1
	}

install_go_and_python() {
	echo $grn"Installing golang, python-pip, python3-pip..."$white
	sudo apt install golang -y >/dev/null 2>&1
	sudo apt install python3-pip python3-dev -y
	sudo curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
	sudo python get-pip.py
	sudo rm get-pip.py
	
	# Installing PyCrypto
	#cd /opt
	#sudo git clone https://github.com/pycrypto/pycrypto.git
	#cd pycrypto
	#sudo python setup.py install
	}



install_terminator() {
	echo $grn"Installing Terminator..."$white
	sudo apt install terminator -y >/dev/null 2>&1
	}


pimpmykali() {
	FILE=/opt/pimpmykali/pimpmykali.sh
	if [ -f "$FILE" ]
	then
		echo $grn"$FILE already exists.  Skipping to next item."$white
		install_ffuf
	else
		echo "***************************************"
		echo "*                                     *"
		echo "*   Script made by Dewalt and will    *"
		echo "*  require some user input. Stand by  *"
		echo "*                                     *"
		echo "***************************************"
		sleep 5
		cd /opt/
		git clone https://github.com/Dewalt-arch/pimpmykali.git >/dev/null 2>&1
		cd pimpmykali
		sudo chmod +x pimpmykali.sh >/dev/null 2>&1
		sudo ./pimpmykali.sh --force
	fi
	}


install_ffuf() {
	FILE=/opt/ffuf/ffuf
	if [ -f "$FILE" ] 
	then
		echo $grn"FFUF exists already, skipping install"$white
		p0wny_shell
	else
		echo $grn"Installing ffuf..."$white
		cd /opt
		sudo git clone https://github.com/ffuf/ffuf.git >/dev/null 2>&1
		cd ffuf
		sudo go build 1> /dev/null
		sudo ln -s /opt/ffuf/ffuf /usr/bin/ffuf 1> /dev/null
	fi
	}



install_p0wny_shell() {
	FILE=/opt/p0wny-shell/README.md
	if [ -f "$FILE" ] 
	then
		echo "$FILE exists already, moving on to next item..."
		install_dirsearch
	else
		echo $grn"Setting up p0wny-shell..."$white
		cd /opt/
		sudo git clone https://github.com/flozz/p0wny-shell.git >/dev/null 2>&1
	fi
	}


install_dirsearch() {
	echo $grn"Installing dirsearch..."$white
	FOLDER=/opt/dirsearch
	if [ -d "$FOLDER" ]
	then
		echo "$FOLDER already exists.  Skipping to next item..."
		install_PEAS
	else
		echo $grn"Installing dirsearch..."$white
		cd /opt/
		sudo git clone https://github.com/maurosoria/dirsearch.git >/dev/null 2>&1
		cd dirsearch
		sudo ln -s /opt/dirsearch.py /usr/bin/dirsearch 1> /dev/null
	fi
	}



install_PEAS() {
	echo $grn"Installing Privilege Escalation Awesome Scripts Suite..."$white
	FOLDER=/opt/privilege-escalation-awesome-scripts-suite
	if [ -d "$FOLDER" ]
	then
		echo "$FOLDER already exists.  Skipping to next item..."
		install_aquatone
	else
		cd /opt/
		sudo git clone https://github.com/carlospolop/privilege-escalation-awesome-scripts-suite.git >/dev/null 2>&1
	fi
	}



install_aquatone() {
	echo $grn"Installing Aquatone..."$white
	FILE=/opt/aquatone/aquatone
	if [ -f "/opt/aquatone/aquatone" ]
	then
		echo "$FILE already exists.  Skipping to next item..."
		install_rsg
	else
		cd /opt/
		sudo git clone https://github.com/michenriksen/aquatone.git >/dev/null 2>&1
		cd aquatone
		sudo go get github.com/michenriksen/aquatone 1> /dev/null
		sudo mv ~/go/bin/aquatone . 1> /dev/null
		sudo ln -s /opt/aquatone/aquatone /usr/bin/aquatone 1> /dev/null
	fi
	}



install_rsg() {
	echo $grn"Installing Reverse Shell Generator..."$white
	FILE=/opt/rsg/rsg
	if [ -f "$FILE" ]
	then
		echo "$FILE already exists.  Skipping to next item..."
		install_knockpy
	else
		cd /opt/
		sudo git clone https://github.com/mthbernardes/rsg.git >/dev/null 2>&1
		cd rsg
		sudo sh install.sh 1> /dev/null
	fi
	}


install_knockpy() {
	echo $grn"Installing KnockPY..."$white
	FOLDER=/opt/knockpy
	if [ -d "$FOLDER" ]
	then
		echo "$FOLDER already exists.  Skipping to next item".
		echo ""
		echo ""
		echo ""
		install_nmap_vulners
	else
		cd /opt
		sudo git clone https://github.com/guelfoweb/knock.git >/dev/null 2>&1
		cd knock
		sudo apt install python-dnspython >/dev/null 2>&1
		python setup.py install 1> /dev/null
	fi
	}


install_nmap_vulners() {
	echo $grn"Installing NMAP Vulners Scripts..."$white
	FOLDER=/opt/nmap-vulners
	if [ -d "$FOLDER" ]
	then
		echo "$FOLDER already exists.  Skipping to next item."
		install_gtfoblookup
	else
		cd /opt
		sudo git clone https://github.com/vulnersCom/nmap-vulners.git >/dev/null 2>&1
		cd nmap-vulners
		cp http-vulners-regex.nse /usr/share/nmap/scripts/ 1> /dev/null
		cp http-vulners-regex.json /usr/share/nmap/nselib/data/ 1> /dev/null
		cp http-vulners-paths.txt /usr/share/nmap/nselib/data/ 1> /dev/null
		nmap --script-updatedb 1> /dev/null
	fi
	}


 install_gtfoblookup() {
	echo $grn"Installing GTFOBLookup..."$white
	cd /opt/
	sudo git clone https://github.com/nccgroup/GTFOBLookup.git >/dev/null 2>&1
	cd GTFOBLookup
	pip3 install -r requirements.txt 1> /dev/null
	python3 gtfoblookup.py update 1> /dev/null
	}


install_navi() {
	echo $grn"Installing NAVI and FZF..."$white
	FOLDER=/opt/navi
	if [ -d "$FOLDER" ]
	then
		echo "$FOLDER already exists.  Skipping to next item."
		install_tomnomnom_stuff
	else
		cd /opt/
		sudo git clone https://github.com/denisidoro/navi.git >/dev/null 2>&1
		cd navi
		# Installing Dependency FZF
		sudo apt install fzf >/dev/null 2>&1
		sudo bash <(curl -sL https://raw.githubusercontent.com/denisidoro/navi/master/scripts/install) 1> /dev/null
	fi
	}


install_tomnomnom_stuff() {
	echo $grn"Installing HTTPROBE..."$white
	cd /opt/
	sudo git clone https://github.com/tomnomnom/httprobe.git >/dev/null 2>&1
	cd httprobe
	sudo go build 1> /dev/null
	sudo ln -s /opt/httprobe/httprobe /usr/bin/httprobe 1> /dev/null
	cd ..

	# Installing WayBackURLS
	echo $grn"Installing WayBackURLS..."$white
	cd /opt/
	sudo git clone https://github.com/tomnomnom/waybackurls.git >/dev/null 2>&1
	cd waybackurls
	sudo go build 1> /dev/null
	ln -s /opt/waybackurls/waybackurls /usr/bin/waybackurls 1> /dev/null

	# Installing HACKS Repository
	echo $grn"Installing HACKS Repository..."$white
	cd /opt
	sudo git clone https://github.com/tomnomnom/hacks.git >/dev/null 2>&1
	
	# Installing UNFURL
	echo $grn"Installing UnFURL..."$white
	cd /opt
	sudo git clone https://github.com/tomnomnom/unfurl.git >/dev/null 2>&1
	cd unfurl
	sudo go get -u github.com/tomnomnom/unfurl 1> /dev/null
	sudo mv /root/go/bin/unfurl /opt/unfurl/ 1> /dev/null
	sudo ln -s /opt/unfurl/unfurl /usr/bin/unfurl 1> /dev/null
	}


install_nahamsec_stuff() {
	echo $grn"Installing Lazyrecon, crtdnstry, jq and rename..."$white
	cd /opt
	sudo git clone https://github.com/nahamsec/lazyrecon.git >/dev/null 2>&1
	cd lazyrecon
	sudo ln -s /opt/lazyrecon/lazyrecon.sh /usr/share/lazyrecon 1> /dev/null
	
	# Modifying lazyrecon to work with current downloaded/installed files from this script 
	sudo sed -i 's/~\/tools/\/opt/g' lazyrecon.sh 1> /dev/null
	sudo sed -i 's/python \/opt\/Sublist3r\/sublist3r.py/sublist3r/g' lazyrecon.sh 1> /dev/null
	sudo sed -i 's/\/opt\/SecLists/\/usr\/share\/seclists/g' lazyrecon.sh 1> /dev/null


	cd /opt
	sudo git clone https://github.com/nahamsec/crtndstry.git >/dev/null 2>&1
	cd /opt
	sudo apt install jq -y >/dev/null 2>&1
	sudo apt install rename -y >/dev/null 2>&1
	}


install_Bloodhound() {
	echo $grn"Installing Bloodhound and downloading SharpHound..."$white
	FOLDER=/opt/Bloodhound
	if [ -d "$FOLDER" ]
	then
		echo "Bloodhound is already installed.  Skipping to next item."
		install_sublist3r
	else
		echo $grn"Installing neo4j..."$white
		wget -O - https://debian.neo4j.com/neotechnology.gpg.key | sudo sudo apt-key add - 1> /dev/null
		echo 'deb https://debian.neo4j.com stable 4.0' > /etc/sudo apt/sources.list.d/neo4j.list 1> /dev/null
		sudo apt-get update >/dev/null 2>&1
		sudo apt-get install neo4j >/dev/null 2>&1
		sudo apt install bloodhound -y >/dev/null 2>&1
		cd /opt
		sudo git clone https://github.com/BloodHoundAD/SharpHound.git >/dev/null 2>&1
	fi	
	}


install_sublist3r() {
	echo $grn"Installing sublist3r"$white
	sudo apt install sublist3r -y >/dev/null 2>&1
	}


installing_asnlookup() {
	echo $grn"Installing asnlookup..."$white
	FILE=/opt/asnlookup/asnlookup.py
	if [ -f "$FILE" ]
	then
		echo "asnlookup is already setup.  Skipping to next item."
		intstall_evil_winrm
	else
		cd /opt
		sudo git clone https://github.com/yassineaboukir/asnlookup.git >/dev/null 2>&1
		cd asnlookup
		pip3 install -r requirements.txt 1> /dev/null
	fi	
	}


install_evil_winrm() {
	echo $grn"Installing Evil-WinRM..."$white
	sudo gem install evil-winrm 1> /dev/null
	}


install_powercat() {
	echo $grn"Installing Powercat..."$white
	cd /opt
	sudo git clone https://github.com/besimorhino/powercat.git >/dev/null 2>&1
	}


install_more_wordlists() {
	echo $grn"Getting more wordlists..."$white
	cd /opt
	sudo git clone https://github.com/ZephrFish/Wordlists.git >/dev/null 2>&1
	}
	
	
install_gobuster() {
	echo $grn"Installing GoBuster..."$white
	FOLDER=/opt/gobuster
	if [ -f "$FOLDER" ]
	then
		echo "Gobuster seems to be installed already."
		install_recursivegobuster
	else
		sudo apt install gobuster -y >/dev/null 2>&1
	fi
	}
	
	
install_recursivegobuster() {
	echo $grn"Installing recursive-gobuster..."$white
	cd /opt/
	sudo git clone https://github.com/epi052/recursive-gobuster.git >/dev/null 2>&1
	
	}


install_enum4linux_ng() {
	echo $grn"Installing enum4linux-ng..."$white
	cd /opt
	sudo git clone https://github.com/cddmp/enum4linux-ng.git >/dev/null 2>&1
	cd enum4linux-ng
	sudo pip3 install -r requirements.txt 1> /dev/null
	}

install_evilportals_wifipineapple() {
	echo $grn"Installing Evil Portals for WiFI Pineapple..."$white
	cd /opt
	sudo git clone https://github.com/kbeflo/evilportals.git >/dev/null 2>&1
	}

install_stegoVeritas() {
	echo $grn"Installing stegoVeritas for all of those steganography nerds out there..."$white
	sudo pip3 install stegoveritas 1> /dev/null
	stegoveritas_install_deps 1> /dev/null
	}
	
install_crackmapexec() {
	echo $grn"Installing CrackMapExec..."$white
	sudo apt install crackmapexec -y >/dev/null 2>&1
	}

snag_random_repos() {
	echo $grn"Setting up OSCP Prep Material, SUID3NUM, linuxprivchecker and The Bug Bounty Methodology..."$white
	cd /opt
	sudo git clone https://github.com/thelinuxchoice/OSCP-Preparation-Material.git >/dev/null 2>&1
	sudo git clone https://github.com/Anon-Exploiter/SUID3NUM.git >/dev/null 2>&1
	sudo git clone https://github.com/sleventyeleven/linuxprivchecker.git >/dev/null 2>&1
	sudo git clone https://github.com/jhaddix/tbhm.git >/dev/null 2>&1
	}
	
	
install_legion() {
	echo $grn"Installing Legion..."$white
	cd /opt
	sudo git clone https://github.com/carlospolop/legion.git >/dev/null 2>&1
	cd /opt/legion/git
	sudo ./install.sh >/dev/null 2>&1
	sudo ln -s /opt/legion/legion.py /usr/bin/legion >/dev/null 2>&1
	}

install_dnstwist() {
	echo $grn"Installing DNSTwist..."$white
	sudo pip3 install dnstwist 1> /dev/null
	}
	
install_spoofcheck() {
	echo $grn"Installing spoofcheck..."$white
	cd /opt
	sudo git clone https://github.com/BishopFox/spoofcheck.git >/dev/null 2>&1
	cd spoofcheck
	sudo pip install -r requirements.txt 1> /dev/null
	}

install_autoenum() {
	echo $grn"Installing autoenum..."$white
	cd /opt
	sudo git clone https://github.com/Gr1mmie/autoenum.git >/dev/null 2>&1
	cd autoenum
	sudo chmod +x autoenum.sh 1> /dev/null
	}


install_easysploit() {
	echo $grn"Installing easysploit..."$white
	cd /opt
	sudo git clone https://github.com/KALILINUXTRICKSYT/easysploit.git >/dev/null 2>&1
	cd easysploit
	sudo bash installer.sh 1> /dev/null
	}

install_sherlock(){
	echo $grn"Installing sherlock..."$white
	cd /opt
	sudo git clone https://github.com/sherlock-project/sherlock.git >/dev/null 2>&1
	cd sherlock
	sudo pip3 install -r requirements.txt 1> /dev/null
	}
	
	

install_threader3000() {
	echo $grn"Installing threader3000..."$white
	sudo pip3 install threader3000 1> /dev/null
	}
	

install_locate() {
	echo $grn"Installing locate..."$white
	sudo apt install locate -y >/dev/null 2>&1
	sudo updatedb 1> /dev/null
	}
	

install_seclists() {
	echo $grn"Installing SecLists..."$white
	sudo apt install seclists -y >/dev/null 2>&1
	cd /usr/share/seclists/Discovery/DNS
	sudo cat dns-Jhaddix.txt | head -n -14 > clean-jhaddix-dns.txt 1> /dev/null
	}
	
	
install_dnsdumpster() {
	echo $grn"Installing DNSDumpster..."$white
	cd /opt
	sudo git clone https://github.com/wangoloj/dnsdumpster.git >/dev/null 2>&1
	cd dnsdumpster
	sudo pip3 install -r requirements.txt 1> /dev/null
	}
	
	
install_github_search() {
	echo $grn"Installing Github_Search..."$white
	cd /opt
	sudo git clone https://github.com/gwen001/github-search.git >/dev/null 2>&1
	cd github-search
	sudo pip3 install -r requirements3.txt 1> /dev/null
	}
	
	
install_shodan_cli() {
	echo $grn"Installing Shodan CLI..."$white
	sudo pip3 install shodan 1> /dev/null
	}
	
	
	
install_interlace() {
	echo $grn"Installing Interlace..."$white
	cd /opt/
	sudo git clone https://github.com/codingo/Interlace.git >/dev/null 2>&1
	cd Interlace
	sudo python3 setup.py install 1> /dev/null
	}
	
	
install_certspotter() {
	echo $grn"Installing Certspotter..."$white
	cd /opt
	sudo git clone https://github.com/SSLMate/certspotter.git >/dev/null 2>&1
	sudo go get software.sslmate.com/src/certspotter/cmd/certspotter 1> /dev/null
	sudo mv ~/go/bin/certspotter /opt/certspotter/certspotter 1> /dev/null
	sudo ln -s /opt/certspotter/certspotter /usr/bin/certspotter 1> /dev/null
	}
	
	
	
install_cloudbrute() {
	echo $grn"Installing CloudBrute..."$white
	cd /opt
	sudo git clone https://github.com/jhaddix/CloudBrute.git >/dev/null 2>&1
	cd CloudBrute
	sudo go build -o CloudBrute main.go >/dev/null 2>&1
	sudo ln -s /opt/CloudBrute/CloudBrute /usr/bin/CloudBrute 1> /dev/null
	}
	
	
	
install_gau() {
	echo $grn"Installing gau..."$white
	cd /opt
	sudo git clone https://github.com/lc/gau.git >/dev/null 2>&1
	cd gau
	sudo go build -o gau >/dev/null 2>&1
	sudo ln -s /opt/gau/gau /usr/bin/gau 1> /dev/null
	}
	
	
	
install_masscan() {
	echo $grn"Removing preinstalled masscan and installing masscan from source..."$white
	sudo apt purge masscan -y >/dev/null 2>&1
	cd /opt
	sudo apt-get install git gcc make libpcap-dev -y >/dev/null 2>&1
	sudo git clone https://github.com/robertdavidgraham/masscan.git >/dev/null 2>&1
	cd masscan
	sudo make 1> /dev/null
	sudo ln -s /opt/masscan/bin/masscan /usr/bin/masscan 1> /dev/null
	}
	

install_massdns() {
	echo $grn"Installing massdns..."$white
	cd /opt
	sudo git clone https://github.com/blechschmidt/massdns.git >/dev/null 2>&1
	cd massdns
	sudo make 1> /dev/null
	sudo ln -s /opt/massdns/bin/massdns /usr/bin/massdns 1> /dev/null
	}



fix_sources
install_go_and_python
install_terminator
pimpmykali
install_ffuf
install_p0wny_shell
install_dirsearch
install_PEAS
install_aquatone
install_rsg
#install_knockpy
install_nmap_vulners
install_gtfoblookup
install_navi
install_tomnomnom_stuff
install_nahamsec_stuff
install_Bloodhound
install_sublist3r
installing_asnlookup
install_evil_winrm
install_powercat
install_more_wordlists
install_gobuster
install_recursivegobuster
install_enum4linux_ng
install_evilportals_wifipineapple
install_stegoVeritas
install_crackmapexec
snag_random_repos
install_legion
install_dnstwist
install_spoofcheck
install_autoenum
install_easysploit
install_sherlock
install_threader3000
install_locate
install_seclists
install_dnsdumpster
install_github_search
install_shodan_cli
install_interlace
install_certspotter
install_cloudbrute
install_gau
#install_masscan
install_massdns



clear
echo "Holy crap!!!  It's over!  FREEEEEEDOOOOOMMMMEEE!"
echo "Now go forth and always remember..."
echo $red" _                _      _   _                  _                  _   "
echo "| |__   __ _  ___| | __ | |_| |__   ___   _ __ | | __ _ _ __   ___| |_ "
echo "| '_ \ / _\` |/ __| |/ / | __| '_ \ / _ \ | '_ \| |/ _\` | '_ \ / _ \ __|"
echo "| | | | (_| | (__|   <  | |_| | | |  __/ | |_) | | (_| | | | |  __/ |_ "
echo "|_| |_|\__,_|\___|_|\_\  \__|_| |_|\___| | .__/|_|\__,_|_| |_|\___|\__|"
echo "                                         |_|     "$white
