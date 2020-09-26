#!/bin/bash
#
# Simple script to reach out and get some toys for Kali Linux 2020.X to help collect recon/bug bounty/fuzzing tools
#
#
# Usage: 
# chmod +x setup_tools.sh
# ./setup_tools.sh

fix_sources() {
	echo "deb http://http.kali.org/kali kali-rolling main non-free contrib" > /etc/apt/sources.list
	echo "deb-src http://http.kali.org/kali kali-rolling main non-free contrib" >> /etc/apt/sources.list
	sudo apt update
	}

install_go_and_python() {
	sudo apt install golang -y
	#sudo apt install python3-pip python3-dev -y
	#sudo curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
	#sudo python get-pip.py
	#sudo rm get-pip.py
	
	# Installing PyCrypto
	#cd /opt
	#sudo git clone https://github.com/pycrypto/pycrypto.git
	#cd pycrypto
	#sudo python setup.py install
	}



install_terminator() {
	sudo apt install terminator -y
	}


pimpmykali() {
	FILE=/opt/pimpmykali/pimpmykali.sh
	if [ -f "$FILE" ]
	then
		echo "$FILE already exists.  Skipping to next item."
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
		git clone https://github.com/Dewalt-arch/pimpmykali.git
		cd pimpmykali
		sudo chmod +x pimpmykali.sh
		./pimpmykali.sh
	fi
	}


install_ffuf() {
	FILE=/opt/ffuf/ffuf
	if [ -f "$FILE" ] 
	then
		echo "FFUF exists already, skipping install"
		p0wny_shell
	else
		cd /opt
		sudo git clone https://github.com/ffuf/ffuf.git
		cd ffuf
		sudo go build
		sudo ln -s /opt/ffuf/ffuf /usr/bin/ffuf
	fi
	}



install_p0wny_shell() {
	FILE=/opt/p0wny-shell/README.md
	if [ -f "$FILE" ] 
	then
		echo "$FILE exists already, moving on to next item..."
		install_dirsearch
	else
		cd /opt/
		sudo git clone https://github.com/flozz/p0wny-shell.git
	fi
	}


install_dirsearch() {
	FOLDER=/opt/dirsearch
	if [ -d "$FOLDER" ]
	then
		echo "$FOLDER already exists.  Skipping to next item..."
		install_PEAS
	else
		cd /opt/
		sudo git clone https://github.com/maurosoria/dirsearch.git
		cd dirsearch
		sudo ln -s /opt/dirsearch.py /usr/bin/dirsearch
	fi
	}



install_PEAS() {
	echo "Installing Privilege Escalation Awesome Scripts Suite..."
	FOLDER=/opt/privilege-escalation-awesome-scripts-suite
	if [ -d "$FOLDER" ]
	then
		echo "$FOLDER already exists.  Skipping to next item..."
		install_aquatone
	else
		cd /opt/
		sudo git clone https://github.com/carlospolop/privilege-escalation-awesome-scripts-suite.git
	fi
	}



install_aquatone() {
	echo "Installing Aquatone..."
	FILE=/opt/aquatone/aquatone
	if [ -f "/opt/aquatone/aquatone" ]
	then
		echo "$FILE already exists.  Skipping to next item..."
		install_rsg
	else
		cd /opt/
		sudo git clone https://github.com/michenriksen/aquatone.git
		cd aquatone
		sudo go get github.com/michenriksen/aquatone
		sudo mv ~/go/bin/aquatone .
		sudo ln -s /opt/aquatone/aquatone /usr/bin/aquatone
	fi
	}



install_rsg() {
	echo "Installing Reverse Shell Generator..."
	FILE=/opt/rsg/rsg
	if [ -f "$FILE" ]
	then
		echo "$FILE already exists.  Skipping to next item..."
		install_knockpy
	else
		cd /opt/
		sudo git clone https://github.com/mthbernardes/rsg.git
		cd rsg
		sudo sh install.sh
	fi
	}


install_knockpy() {
	echo "Installing KnockPY..."
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
		sudo git clone https://github.com/guelfoweb/knock.git
		cd knock
		sudo apt install python-dnspython
		python setup.py install
	fi
	}


install_nmap_vulners() {
	FOLDER=/opt/nmap-vulners
	if [ -d "$FOLDER" ]
	then
		echo "$FOLDER already exists.  Skipping to next item."
		install_gtfoblookup
	else
		cd /opt
		sudo git clone https://github.com/vulnersCom/nmap-vulners.git
		cd nmap-vulners
		cp nmap-vulners/http-vulners-regex.nse /usr/share/nmap/scripts/
		cp http-vulners-regex.json /usr/share/nmap/nselib/data/
		cp http-vulners-paths.txt /usr/share/nmap/nselib/data/
		nmap --script-updatedb
	fi
	}


 install_gtfoblookup() {
	cd /opt/
	sudo git clone https://github.com/nccgroup/GTFOBLookup.git
	cd GTFOBLookup
	pip3 install -r requirements.txt
	python3 gtfoblookup.py update
	}


install_navi() {
	FOLDER=/opt/navi
	if [ -d "$FOLDER" ]
	then
		echo "$FOLDER already exists.  Skipping to next item."
		echo ""
		echo ""
		echo ""
		install_tomnomnom_stuff
	else
		cd /opt/
		sudo git clone https://github.com/denisidoro/navi.git
		cd navi
		# Installing Dependency FZF
		sudo apt install fzf
		bash <(curl -sL https://raw.githubusercontent.com/denisidoro/navi/master/scripts/install)
	fi
	}


install_tomnomnom_stuff() {
	# Installing HTTPROBE
	cd /opt/
	sudo git clone https://github.com/tomnomnom/httprobe.git
	cd httprobe
	sudo go build
	sudo ln -s /opt/httprobe/httprobe /usr/bin/httprobe
	cd ..

	# Installing WayBackURLS
	cd /opt/
	sudo git clone https://github.com/tomnomnom/waybackurls.git
	cd waybackurls
	sudo go build
	ln -s /opt/waybackurls/waybackurls /usr/bin/waybackurls

	# Installing HACKS Repository
	cd /opt
	sudo git clone https://github.com/tomnomnom/hacks.git
	
	# Installing UNFURL
	cd /opt
	sudo git clone https://github.com/tomnomnom/unfurl.git
	cd unfurl
	sudo go get -u github.com/tomnomnom/unfurl
	sudo mv /root/go/bin/unfurl /opt/unfurl/
	sudo ln -s /opt/unfurl/unfurl /usr/bin/unfurl
	}


install_nahamsec_stuff() {
	cd /opt
	sudo git clone https://github.com/nahamsec/lazyrecon.git
	cd lazyrecon
	sudo ln -s /opt/lazyrecon/lazyrecon.sh /usr/share/lazyrecon
	cd /opt
	sudo git clone https://github.com/nahamsec/crtndstry.git
	sudo git clone https://github.com/nahamsec/JSParser.git
	cd JSParser
	python2.7 setup install
	cd /opt
	sudo apt install jq -y
	sudo apt install rename -y
	}


install_Bloodhound() {
	echo "Installing Bloodhound and downloading SharpHound..."
	FOLDER=/opt/Bloodhound
	if [ -d "$FOLDER" ]
	then
		echo "Bloodhound is already installed.  Skipping to next item."
		install_sublist3r
	else
		echo "Installing neo4j..."
		wget -O - https://debian.neo4j.com/neotechnology.gpg.key | sudo sudo apt-key add -
		echo 'deb https://debian.neo4j.com stable 4.0' > /etc/sudo apt/sources.list.d/neo4j.list
		sudo sudo apt-get update
		sudo apt-get install neo4j -y
		sudo apt install bloodhound -y
		cd /opt
		sudo git clone https://github.com/BloodHoundAD/SharpHound.git
	fi	
	}


install_sublist3r() {
	echo "installing sublist3r"
	sudo apt install sublist3r -y
	echo "done"
	}


installing_asnlookup() {
	echo "Installing asnlookup..."
	FILE=/opt/asnlookup/asnlookup.py
	if [ -f "$FILE" ]
	then
		echo "asnlookup is already setup.  Skipping to next item."
		intstall_evil_winrm
	else
		cd /opt
		sudo git clone https://github.com/yassineaboukir/asnlookup.git
		cd asnlookup
		pip3 install -r requirements.txt
	fi	
	}


install_evil_winrm() {
	echo "Installing Evil-WinRM..."
	sudo gem install evil-winrm
	}


install_powercat() {
	echo "Installing Powercat..."
	cd /opt
	sudo git clone https://github.com/besimorhino/powercat.git
	}


install_more_wordlists() {
	echo "Getting more wordlists..."
	cd /opt
	sudo git clone https://github.com/ZephrFish/Wordlists.git
	}
	
	
install_gobuster() {
	echo "Installing GoBuster..."
	FOLDER=/opt/gobuster
	if [ -f "$FOLDER" ]
	then
		echo "Gobuster seems to be installed already."
		install_recursivegobuster
	else
		sudo apt install gobuster -y
	fi
	}
	
	
install_recursivegobuster() {
	echo "Installing recursive-gobuster..."
	cd /opt/
	sudo git clone https://github.com/epi052/recursive-gobuster.git
	
	}


install_enum4linux_ng() {
	echo "Installing enum4linux-ng..."
	cd /opt
	sudo git clone https://github.com/cddmp/enum4linux-ng.git
	cd enum4linux-ng
	sudo pip3 install -r requirements.txt
	}

install_evilportals_wifipineapple() {
	echo "Installing Evil Portals for WiFI Pineapple..."
	cd /opt
	sudo git clone https://github.com/kbeflo/evilportals.git
	}

install_stegoVeritas() {
	echo "Installing stegoVeritas for all of those steganography nerds out there..."
	sudo pip3 install stegoveritas
	stegoveritas_install_deps
	}
	
install_crackmapexec() {
	echo "Installing CrackMapExec..."
	sudo apt install crackmapexec -y	
	}

snag_random_repos() {
	cd /opt
	sudo git clone https://github.com/thelinuxchoice/OSCP-Preparation-Material.git
	sudo git clone https://github.com/Anon-Exploiter/SUID3NUM.git
	sudo git clone https://github.com/sleventyeleven/linuxprivchecker.git
	sudo git clone https://github.com/jhaddix/tbhm.git
	}
	
	
install_legion() {
	cd /opt
	sudo git clone https://github.com/carlospolop/legion.git
	cd /opt/legion/git
	sudo ./install.sh
	sudo ln -s /opt/legion/legion.py /usr/bin/legion
	}

install_dnstwist() {
	sudo pip3 install dnstwist
	}
	
install_spoofcheck() {
	cd /opt
	sudo git clone https://github.com/BishopFox/spoofcheck.git
	cd spoofcheck
	sudo pip install -r requirements.txt
	}

install_autoenum() {
	cd /opt
	sudo git clone https://github.com/Gr1mmie/autoenum.git
	cd autoenum
	sudo chmod +x autoenum.sh
	}


install_easysploit() {
	echo "Installing easysploit..."
	cd /opt
	sudo git clone https://github.com/KALILINUXTRICKSYT/easysploit.git
	cd easysploit
	sudo bash installer.sh
	}

install_sherlock(){
	cd /opt
	sudo git clone https://github.com/sherlock-project/sherlock.git
	cd sherlock
	sudo pip3 install -r requirements.txt
	}
	
	

install_threader3000() {
	sudo pip3 install threader3000
	}
	

install_locate() {
	echo "Installing locate..."
	sudo apt install locate -y
	sudo updatedb
	}
	

install_seclists() {
	sudo apt install seclists -y
	cd /usr/share/seclists/Discovery/DNS
	sudo cat dns-Jhaddix.txt | head -n -14 > clean-jhaddix-dns.txt
	}
	
	
install_dnsdumpster() {
	cd /opt
	sudo git clone https://github.com/wangoloj/dnsdumpster.git
	cd dnsdumpster
	sudo pip3 install -r requirements.txt
	}
	
	
install_github_search() {
	cd /opt
	sudo git clone https://github.com/gwen001/github-search.git
	cd github-search
	sudo pip3 install -r requirements3.txt
	}
	
	
install_shodan_cli() {
	sudo pip3 install shodan
	}
	
	
	
install_interlace() {
	cd /opt/
	sudo git clone https://github.com/codingo/Interlace.git
	cd Interlace
	sudo python3 setup.py install
	}
	
	
install_certspotter() {
	cd /opt
	sudo git clone https://github.com/SSLMate/certspotter.git
	sudo go get software.sslmate.com/src/certspotter/cmd/certspotter
	sudo mv ~/go/bin/certspotter /opt/certspotter/certspotter
	sudo ln -s /opt/certspotter/certspotter /usr/bin/certspotter
	}
	
	
	
install_cloudbrute() {
	cd /opt
	sudo git clone https://github.com/jhaddix/CloudBrute.git
	cd CloudBrute
	sudo go build -o CloudBrute main.go
	sudo ln -s /opt/CloudBrute/CloudBrute /usr/bin/CloudBrute
	}
	
	
	
install_gau() {
	cd /opt
	sudo git clone https://github.com/lc/gau.git
	cd gau
	sudo go build -o gau
	sudo ln -s /opt/gau/gau /usr/bin/gau
	}
	
	
	
install_masscan() {
	echo "Removing preinstalled masscan and installing masscan from source..."
	sudo apt purge masscan -y
	cd /opt
	sudo apt-get install git gcc make libpcap-dev -y
	sudo git clone https://github.com/robertdavidgraham/masscan.git
	cd masscan
	sudo make
	sudo ln -s /opt/masscan/bin/masscan /usr/bin/masscan
	}
	

install_massdns() {
	cd /opt
	sudo git clone https://github.com/blechschmidt/massdns.git
	cd massdns
	sudo make
	sudo ln -s /opt/massdns/bin/massdns /usr/bin/massdns
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
install_knockpy
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
install_masscan
install_massdns



clear
echo "Holy crap!!!  It's over!  FREEEEEEDOOOOOMMMMEEE!"
echo "Now go forth and always remember..."
echo " _                _      _   _                  _                  _   "
echo "| |__   __ _  ___| | __ | |_| |__   ___   _ __ | | __ _ _ __   ___| |_ "
echo "| '_ \ / _\` |/ __| |/ / | __| '_ \ / _ \ | '_ \| |/ _\` | '_ \ / _ \ __|"
echo "| | | | (_| | (__|   <  | |_| | | |  __/ | |_) | | (_| | | | |  __/ |_ "
echo "|_| |_|\__,_|\___|_|\_\  \__|_| |_|\___| | .__/|_|\__,_|_| |_|\___|\__|"
echo "                                         |_|     "
