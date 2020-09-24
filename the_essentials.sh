#!/bin/bash
#
# Simple script to reach out and get some toys for Kali Linux 2020.X to help collect recon/bug bounty/fuzzing tools
#
#
# Usage: 
# sudo chmod +x the_essentials.sh
# sudo ./the_essentials.sh

fix_sources() {
	echo "deb http://http.kali.org/kali kali-rolling main non-free contrib" > /etc/apt/sources.list
	echo "deb-src http://http.kali.org/kali kali-rolling main non-free contrib" >> /etc/apt/sources.list
  # Go ahead and run updates.  This can take a while...
	sudo apt update && sudo apt upgrade -y && sudo apt autoclean -y && sudo apt autoremove -y && apt full-upgrade -y && apt dist-upgrade -y
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
		chmod +x pimpmykali.sh
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
		sh install.sh
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
		install_navi
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
		make install
		# Installing Dependency FZF
		sudo apt install fzf
		#bash <(curl -sL https://raw.githubusercontent.com/denisidoro/navi/master/scripts/install)
	fi
	}


install_tomnomnom_stuff() {
	# Installing HTTPROBE
	cd /opt/
	sudo git clone https://github.com/tomnomnom/httprobe.git
	cd httprobe
	sudo go build
	ln -s /opt/httprobe /usr/bin/httprobe
	cd ..

	# Installing WayBackURLS
	cd /opt/
	sudo git clone https://github.com/tomnomnom/waybackurls.git
	cd waybackurls
	sudo go build
	ln -s /opt/waybackurls/waybackurls /usr/bin/waybackurls

	# Installing HACKS Repository
	cd /opt
	sudo git clone https://github.com/tomnomnom/hacks.sudo git
	
	# Installing UNFURL
	cd /opt
	sudo git clone https://github.com/obsidianforensics/unfurl.git
	}


install_nahamsec_stuff() {
	cd /opt
	sudo git clone https://sudo github.com/nahamsec/lazyrecon.git
	cd lazyrecon
	ln -s /opt/lazyrecon/lazyrecon.sh /usr/share/lazyrecon
	cd /opt
	sudo git clone https://github.com/nahamsec/crtndstry.git
	sudo git clone https://github.com/nahamsec/JSParser.git
	cd JSParser
	python2.7 setup install
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
	sudo apt install sublist3r
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
		sudo git clone https://github.com/yassineaboukir/asnlookup.sudo git
		cd asnlookup
		pip3 install -r requirements.txt
	fi	
	}


install_evil_winrm() {
	echo "Installing Evil-WinRM..."
	gem install evil-winrm
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
	

fix_sources
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
install_nahmsec_stuff
install_Bloodhound
install_sublist3r
installing_asnlookup
install_evil_winrm
install_powercat
install_more_wordlists
