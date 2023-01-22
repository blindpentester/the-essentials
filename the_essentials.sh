#!/bin/bash
#
# Simple script to reach out and get some toys for Kali Linux 2020.X to help collect recon/bug bounty/fuzzing tools
#
#
# Usage:
# sudo ./the_essentials.sh



black=$(tput setaf 0)
red=$(tput setaf 1)
green=$(tput setaf 2)
yellow=$(tput setaf 3)
blue=$(tput setaf 4)
magenta=$(tput setaf 5)
cyan=$(tput setaf 6)
white=$(tput setaf 7)

skip=0    # Add skip=0 up here by colors

	if [ "$EUID" -ne 0 ]
	then echo -e "${green}\n\n Script must be run with sudo ./the_essentials.sh or as root \n"$grn
	exit
	fi

echo "${green}Performing a git pull on all /opt folders now to make sure they are up to date..."
find /opt -maxdepth 1 -type d -exec bash -c 'cd "{}"; git pull;' \;>/dev/null 2>&1


# Function to check version numbers of repository releases
check_latest_version() {
    repository=$1
    latest_version=$(curl --silent https://api.github.com/repos/"$repository"/releases/latest)
    echo "Latest version of $repository is: $latest_version"
}


fix_sources() {
	echo "${green}Fixing sources...${white}"
	echo "deb http://kali.download/kali kali-rolling main non-free contrib" > /etc/apt/sources.list
	echo "deb-src http://kali.download/kali kali-rolling main non-free contrib" >> /etc/apt/sources.list
	apt update >/dev/null 2>&1
	}
	
	
	
install_jq() {

if ! command -v jq &>/dev/null; then
    echo "${green}jq not found, installing...${white}"
    # install jq
    sudo apt-get install jq -y  >/dev/null 2>&1
else
    echo "${green}jq found, checking for updates...${white}"
    # check for updates
    sudo apt-get update >/dev/null 2>&1
    sudo apt-get install jq -y >/dev/null 2>&1
fi

}


install_docker() {
    if ! command -v docker >/dev/null 2>&1; then
        echo -e "${green}Installing Docker...${green}"
        export DEBIAN_FRONTEND=noninteractive
        apt install docker.io -y >/dev/null 2>&1
    else
        echo -e "\033[32mDocker is already installed.\033[0m"
    fi
}




install_go() {
	command -v go >/dev/null 2>&1 || {
		echo "${green}Installing golang...${white}"
		apt install golang -y >/dev/null 2>&1
	}
		command -v go >/dev/null 2>&1 && echo "${green}golang already installed, lets see if it needs to be updated...${white}"
		apt upgrade golang -y >/dev/null 2>&1
	}



install_pip() {
	command -v pip >/dev/null 2>&1 || {
		echo "${green}Installing pip...${white}"
		curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py >/dev/null 2>&1
		python get-pip.py >/dev/null 2>&1
		rm get-pip.py
	}
		command -v pip >/dev/null 2>&1 && echo "${green}pip already installed, move along...${white}"
	}


install_pip3() {
	command -v pip3 >/dev/null 2>&1 || {
		echo "${green}Installing pip3...${white}"
		apt install python3-pip -y >/dev/null 2>&1
	}
		command -v pip3 >/dev/null 2>&1 && echo "${green}pip3 already installed, move along...${white}"
	}


install_terminator() {
	command -v terminator >/dev/null 2>&1 || {
		echo "${green}Installing Terminator...${white}"
		apt install terminator -y >/dev/null 2>&1
		}
	command -v terminator >/dev/null 2>&1 && echo "${green}Terminator already installed, move along...${white}"
	}






pimpmykali() {
  if [ $skip = 0 ]  # this HAS to be $skip = 0 no -ne or anything fancy
  then
    FILE=/opt/pimpmykali/pimpmykali.sh
      if [ -f "$FILE" ]
      then
        echo "${green}$FILE already exists.  Skipping to next item.${white}"
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
        else
          echo "${green}skipping pimpmykali.sh --skippimp was used${white}"
          cd /opt
          git clone https://github.com/Dewalt-arch/pimpmykali.git >/dev/null 2>&1
          cd pimpmykali
          git pull >/dev/null 2>&1
    fi
  }



install_ffuf() {
apt uninstall ffuf >/dev/null 2>&1
dpkg -s ffuf &>/dev/null
	if [ $? -ne 0 ]; then
		printf '%b\n' "$(tput setaf 2)Installing ffuf...$(tput sgr0)"
		# Clone the ffuf repository and create a symlink to the binary
		echo y | ffuf >/dev/null
	else
		printf '%b\n' "$(tput setaf 2)Verifying you are on latest version of ffuf...$(tput sgr0)"
		ffufCurentVersion=$(ffuf -V | cut -d " " -f 3)
		ffufreleases=$(curl -s https://api.github.com/repos/ffuf/ffuf/releases/latest | jq -r '.assets[].browser_download_url')
		linux_releases=$(echo "$ffufreleases" | grep "linux")
		ffuflatest=$(echo "$linux_releases" | head -n 1)
		ffuflatest=$(echo $ffuflatest | cut -d "/" -f8 | cut -d "v" -f2)
		if [ "$ffufCurentVersion" != "$ffuflatest" ]; then
			# Download and install the new version of ffuf
			printf '%b\n' "$(tput setaf 1)Removing legacy ffuf...$(tput sgr0)"
			rm -rf /opt/ffuf >/dev/null 2>&1
			rm /usr/bin/ffuf >/dev/null 2>&1
			printf '%b\n' "$(tput setaf 1)Updating ffuf to version ${ffuflatest}...$(tput sgr0)"
			echo y | ffuf >/dev/null 2>&1
	fi
		fi
			}		



install_dirsearch() {
	DIRSEARCH_FOLDER=/opt/dirsearch
	if [ ! -d "$DIRSEARCH_FOLDER" ]
	then
		echo "${green}Installing dirsearch...${white}"
		cd /opt/
		git clone https://github.com/maurosoria/dirsearch >/dev/null 2>&1
		cd dirsearch
		python3 setup.py install >/dev/null 2>&1
	else
		echo "${green}dirsearch appears to be installed already.${white}"
		echo "${green}		checking to see if it is up to date...${white}"

		# Store the current version of dirsearch on the system
		dirsearchCurrentVer=$(dirsearch --version | cut -d " " -f2)

		# Store the latest version of dirsearch available on GitHub
		dirsearchlatestver=$(curl -s https://api.github.com/repos/maurosoria/dirsearch/releases/latest | jq -r '.tag_name')

		# Compare the two version numbers
        if [[ $dirsearchCurrentVer != $dirsearchlatestver ]]; then
		# Download the latest version
		echo "${green}Does not show you are on the current version, lets fix that...${white}"
		cd $DIRSEARCH_FOLDER
		git pull >/dev/null 2>&1
		python3 setup.py install >/dev/null 2>&1
	else
		echo "${green}		dirsearch is already up-to-date${white}"
		fi

	fi
}


install_PEAS() {
	FOLDER=/opt/PEASS-ng
	OLD_FOLDER=/opt/privilege-escalation-awesome-scripts-suite
	if [ -d "$OLD_FOLDER" ]; then
		echo "${green}Removing old version...${white}"
		rm -rf "$OLD_FOLDER"
	fi
	if [ -d "$FOLDER" ]; then
		echo "${green}Privilege Escalation Awesome Scripts Suite already exists. Updating...${white}"
		cd "$FOLDER"
		git pull origin master >/dev/null 2>&1
		echo "${green}	Downloading compiled binaries to /opt/PEASS-ng/binaries...${white}"
		rm -rf "$FOLDER/binaries" 
		mkdir "$FOLDER/binaries" 
		response=$(curl -s https://api.github.com/repos/carlospolop/PEASS-ng/releases/latest)
		binary_urls=$(echo $response | jq -r '.assets[].browser_download_url')
	    	binary_urls_array=($(echo $binary_urls | tr ' ' '\n'))
	for url in "${binary_urls_array[@]}"; do
		wget -q -P "$FOLDER/binaries" "$url"
		done
	else
		cd /opt
		git clone https://github.com/carlospolop/PEASS-ng "$FOLDER"
		echo "${green}Downloading compiled binaries to /opt/PEASS-ng/binaries...${white}"
		rm -rf "$FOLDER/binaries"
		mkdir "$FOLDER/binaries"
		response=$(curl -s https://api.github.com/repos/carlospolop/PEASS-ng/releases/latest)
		binary_urls=$(echo $response | jq -r '.assets[].browser_download_url')
	    	binary_urls_array=($(echo $binary_urls | tr ' ' '\n'))
	for url in "${binary_urls_array[@]}"; do
		wget -q -P "$FOLDER/binaries" "$url"
		done
	fi
	}




install_linenum() {
	FOLDER=/opt/LinEnum
	if [ -d "$FOLDER" ]
	then
		echo "${green}LinEnum has not been updated in years. Stick a fork in it, its done."
		echo "${green}LinEnum exists on here, lets fix that by removing it.${white}"
		rm -rf /opt/LinEnum
	else
		echo "${green}Killing LinEnum from essentials..."
	fi
	}



install_aquatone() {
	# Check if Aquatone is already installed
	if ! hash aquatone 2>/dev/null; then
		printf '%b\n' "$(tput setaf 2)Installing Aquatone...$(tput sgr0)"
		# Clone the Aquatone repository and create a symlink to the binary
		cd /opt/
		git clone https://github.com/michenriksen/aquatone.git >/dev/null 2>&1
		cd aquatone
		atreleases=$(curl -s https://api.github.com/repos/michenriksen/aquatone/releases/latest | jq -r '.assets[].browser_download_url')
		linux_releases=$(echo "$atreleases" | grep "linux")
		atlatest=$(echo "$linux_releases" | head -n 1)
		curl -LJO $atlatest
		unzip aquatone*.zip -d zip
		cd zip
		ln -sf /opt/aquatone/zip/aquatone /usr/bin/aquatone >/dev/null 2>&1
	else
		printf '%b\n' "$(tput setaf 2)Checking for updates to Aquatone...$(tput sgr0)"
		# Check if the installed version is up-to-date
		atcurrentver=$(aquatone -version | cut -d " " -f2)
		atlatestver=$(curl -s https://api.github.com/repos/michenriksen/aquatone/releases/latest | jq -r '.tag_name')
		if [ "$atcurrentver" != "$atlatestver" ]; then
			# Download and install the new version of Aquatone
			printf '%b\n' "$(tput setaf 1)Updating Aquatone to version ${atlatestver}...$(tput sgr0)"
			cd /opt/aquatone
			rm -rf zip/ >/dev/null 2>&1
			printf '%b\n' "$(tput setaf 1)Removing legacy aquatone...$(tput sgr0)"
			rm aquatone*.zip >/dev/null 2>&1
			rm /usr/bin/aquatone >/dev/null 2>&1
			wget https://github.com/michenriksen/aquatone/releases/download/$atlatestver/aquatone_linux_amd64_$atlatestver.zip >/dev/null 2>&1
			unzip aquatone*. -d zip
			cd zip
			printf '%b\n' "$(tput setaf 2)Setting symlink to /usr/bin/aquatone...$(tput sgr0)"
			ln -sf /opt/aquatone/zip/aquatone /usr/bin/aquatone >/dev/null 2>&1
		else
			printf '%b\n' "$(tput setaf 2)Aquatone is up-to-date, version ${atcurrentver}$(tput sgr0)"
			fi
		fi
	}



install_rsg() {
	if [[ -d /opt/rsg ]]
	then
		echo "${green}Installing Reverse Shell Generator...${white}"
		cd /opt/
		rm -rf rsg >/dev/null 2>&1
		git clone https://github.com/0dayCTF/reverse-shell-generator >/dev/null 2>&1
		cd reverse-shell-generator
		#npx netlify dev
		if command -v docker >/dev/null 2>&1; then
			docker build -t reverse_shell_generator .
			echo "${green}		To start this, cd into /opt/reverse-shell-generator and run"
			echo "		docker run -d -p 80:80 reverse_shell_generator${white}"
		else
			echo "${red}Docker not found, please install it before running this command${white}"
		fi
	else
		if [[ -d /opt/reverse-shell-generator ]]; then
			echo "${green}Reverse Shell Generator already installed.${white}"
			cd /opt/reverse-shell-generator
			rm -rf rsg >/dev/null 2>&1
			git pull >/dev/null 2>&1
			#npx netlify dev
			if command -v docker >/dev/null 2>&1; then
				docker build -t reverse_shell_generator .
				echo "${green}		To start this, cd into /opt/reverse-shell-generator and run"
				echo "		docker run -d -p 80:80 reverse_shell_generator${white}"
			else
				echo "${red}Docker not found, please install it before running this command${white}"
			fi
		else
			echo "${green}Installing Reverse Shell Generator...${white}"
			cd /opt/
			git clone https://github.com/0dayCTF/reverse-shell-generator >/dev/null 2>&1
			cd reverse-shell-generator
			if command -v docker >/dev/null 2>&1; then
				docker build -t reverse_shell_generator .
				echo "${green}		To start this, cd into /opt/reverse-shell-generator and run"
				echo "		docker run -d -p 80:80 reverse_shell_generator${white}"
			else
				echo "${red}Docker not found, please install it before running this command${white}"
			fi
		fi
	fi
	}



				




install_nmap_vulners() {
	FOLDER=/opt/nmap-vulners
	if [ -d "$FOLDER" ]
	then
		echo "${green}nmap vulners already exists.  Skipping to next item.${white}"
	else
		echo "${green}Installing NMAP Vulners Scripts...${white}"
		cd /opt
		git clone https://github.com/vulnersCom/nmap-vulners.git >/dev/null 2>&1
		cd nmap-vulners
		cp http-vulners-regex.nse /usr/share/nmap/scripts/ 1>/dev/null
		cp http-vulners-regex.json /usr/share/nmap/nselib/data/ 1>/dev/null
		cp http-vulners-paths.txt /usr/share/nmap/nselib/data/ 1>/dev/null
		wget https://svn.nmap.org/nmap/scripts/clamav-exec.nse -O /usr/share/nmap/scripts/clamav-exec.nse >/dev/null 2>&1
		nmap --script-updatedb 1>/dev/null
	fi
	}


 install_gtfoblookup() {
	FOLDER=/opt/GTFOBLookup
	if [ -d "$FOLDER" ]
	then
		echo "${green}$FOLDER already exists.  Skipping to next item...${white}"
	else
		echo "${green}Installing GTFOBLookup...${white}"
		cd /opt/
		git clone https://github.com/nccgroup/GTFOBLookup.git >/dev/null 2>&1
		cd GTFOBLookup
		pip3 install --root-user-action=ignore -r requirements.txt 1>/dev/null
		python3 gtfoblookup.py update 1>/dev/null
	fi
	}


install_navi() {
	FOLDER=/opt/navi
	if [ -d "$FOLDER" ]
	then
		echo "${green}navi already exists.  Skipping to next item.${white}"
	else
		echo "${green}Installing NAVI and FZF...${white}"
		cd /opt/
		git clone https://github.com/denisidoro/navi.git >/dev/null 2>&1
		cd navi
		# Installing Dependency FZF
		apt install fzf >/dev/null 2>&1
		bash <(curl -sL https://raw.githubusercontent.com/denisidoro/navi/master/scripts/install) >/dev/null 2>&1
	fi
	}



install_tom_httprobe() {
	if ! [ -x "$(command -v /opt/httprobe/httprobe)" ]
	then
		echo "${green}Installing httprobe...${white}"
		cd /opt/
		git clone https://github.com/tomnomnom/httprobe.git >/dev/null 2>&1
		cd httprobe
		go build 1>/dev/null
		ln -sf /opt/httprobe/httprobe /usr/bin/httprobe >/dev/null 2>&1
	else
		echo "${green}httprobe appears to be installed already.  moving along...${white}"
		echo "${green}Making sure its up to date${white}"
		cd /opt/httprobe >/dev/null 2>&1
		git pull 1>/dev/null
		rm httprobe
		go build
	fi

	}


install_tom_waybackurls() {
	if ! [ -x "$(command -v waybackurls)" ]
	then
		echo "${green}Installing waybackurls...${white}"
		cd /opt/
		git clone https://github.com/tomnomnom/waybackurls.git >/dev/null 2>&1
		cd waybackurls
		go build 1>/dev/null
		ln -sf /opt/waybackurls/waybackurls /usr/bin/waybackurls >/dev/null 2>&1
	else
		echo "${green}waybackurls appears to be installed already.  moving along...${white}"
		cd /opt/waybackurls
		git pull 1>/dev/null
		rm waybackurls
		go build 1>/dev/null
		
		 
	fi
	}


install_tom_unfurl() {
	if ! [ -x "$(command -v unfurl)" ]
	then
		echo "${green}Installing UnFURL...${white}"
		cd /opt
		git clone https://github.com/tomnomnom/unfurl.git >/dev/null 2>&1
		cd unfurl
		go build 1>/dev/nulll
		ln -sf /opt/unfurl/unfurl /usr/bin/unfurl >/dev/null 2>&1
	else
		echo "${green}unfurl appears to be installed already.  moving along...${white}"
		cd /opt/unfurl
		git pull 1>/dev/null
		go build 1>/dev/null
	fi
	}



install_tom_fff() {
	if ! [ -x "$(command -v fff)" ]
	then
		echo "${green}Installing fff...${white}"
		cd /opt
		git clone https://github.com/tomnomnom/fff.git >/dev/null 2>&1
		cd fff
		go build >/dev/null 2>&1
		ln -sf /opt/fff/fff /usr/bin/fff >/dev/null 2>&1
	else
		echo "${green}fff appears to be installed already.  moving along...${white}"
		cd /opt/fff
		git pull >/dev/null 2>&1
		rm fff
		go build
	fi

	}



install_tom_hacks() {
	FOLDER=/opt/hacks
	if [ -d "$FOLDER" ]
	then
		echo "${green}hacks repo appears to be installed already.  moving along...${white}"
		cd /opt/hacks
		git pull 1>/dev/null
	else
		echo "${green}Installing hacks repository...${white}"
		cd /opt
		git clone https://github.com/tomnomnom/hacks.git >/dev/null 2>&1
		cd hacks
		git pull 1>/dev/null
	fi
	}


install_nahamsec_stuff() {
	echo "${green}Installing crtdnstry, jq and rename...${white}"
	# cd /opt
	# git clone https://github.com/nahamsec/lazyrecon.git >/dev/null 2>&1
	# cd lazyrecon
	# ln -sf /opt/lazyrecon/lazyrecon.sh /usr/share/lazyrecon 1>/dev/null

	# Modifying lazyrecon to work with current downloaded/installed files from this script
	# sed -i 's/~\/tools/\/opt/g' lazyrecon.sh 1>/dev/null
	# sed -i 's/python \/opt\/Sublist3r\/sublist3r.py/sublist3r/g' lazyrecon.sh 1>/dev/null
	# sed -i 's/\/opt\/SecLists/\/usr\/share\/seclists/g' lazyrecon.sh 1>/dev/null


	cd /opt
	git clone https://github.com/nahamsec/crtndstry.git >/dev/null 2>&1
	cd /opt
	apt install jq -y >/dev/null 2>&1
	apt install rename -y >/dev/null 2>&1
	}


install_neo4j() {
	if ! [ -x "$(command -v neo4j)" ]
	then
		echo "${green}Installing neo4j...${white}"
		apt install neo4j -y >/dev/null 2>&1
	else
		echo "${green}neo4j appears to be installed already.  moving along...${white}"
	fi

	}


install_bloodhound() {
	if ! [ -x "$(command -v bloodhound)" ]
	then
		echo "${green}Installing bloodhound...${white}"
		apt install bloodhound -y >/dev/null 2>&1
	else
		echo "${green}bloodhound appears to be installed already.  moving along...${white}"
	fi

	}



install_sublist3r() {
	if ! [ -x "$(command -v sublist3r)" ]
	then
		echo "${green}Installing sublist3r${white}"
		apt install sublist3r -y >/dev/null 2>&1
	else
		echo "${green}sublist3r appears to be installed already.  moving along...${white}"
	fi
	}


installing_asnlookup() {
	echo "${green}Installing asnlookup...${white}"
	FOLDER=/opt/asnlookup
	if [ -d "$FOLDER" ]
	then
		echo "${green}asnlookup is already setup.  Skipping to next item.${white}"
	else
		cd /opt
		git clone https://github.com/yassineaboukir/asnlookup.git >/dev/null 2>&1
		cd asnlookup
		pip3 install --root-user-action=ignore -r requirements.txt 1>/dev/null
	fi
	}


install_evil_winrm() {
	if ! [ -x "$(command -v evil-winrm)" ]
	then
		echo "${green}Installing Evil-WinRM...${white}"
		gem install evil-winrm 1>/dev/null
	else
		echo "${green}evil-winrm appears to be installed already.  moving along...${white}"
	fi
	}


install_powercat() {
	FOLDER=/opt/powercat
	if [ -d "$FOLDER" ]
	then
		echo "${green}powercat is already setup...${white}"
	else
		echo "${green}Installing Powercat...${white}"
		cd /opt
		git clone https://github.com/besimorhino/powercat.git >/dev/null 2>&1
	fi
	}


install_more_wordlists() {
	FOLDER=/opt/Wordlists
	if [ -d "$FOLDER" ]
	then
		echo "${green}Wordlists is already setup...${white}"
	else
		echo "${green}Getting more wordlists...${white}"
		cd /opt
		git clone https://github.com/ZephrFish/Wordlists.git >/dev/null 2>&1
	fi
	}


install_gobuster() {
	if ! [ -x "$(command -v gobuster)" ]
	then
		echo "${green}Installing GoBuster...${white}"
		apt install gobuster -y >/dev/null 2>&1
	else
		echo "${green}gobuster appears to be installed already.  moving along...${white}"

	fi
	}


install_recursivegobuster() {
	FOLDER=/opt/recursive-gobuster
	if [ -d "$FOLDER" ]
	then
		echo "${green}recursive-gobuster appears to be installed already.  moving along...${white}"
	else
		echo "${green}Installing recursive-gobuster...${white}"
		cd /opt/
		git clone https://github.com/epi052/recursive-gobuster.git >/dev/null 2>&1
	fi
	}


install_enum4linux_ng() {
	FOLDER=/opt/enum4linux-ng
	if [ -d "$FOLDER" ]
	then
		echo "${green}enum4linux-ng appears to be installed already.  moving along...${white}"
	else
		echo "${green}Installing enum4linux-ng...${white}"
		cd /opt
		git clone https://github.com/cddmp/enum4linux-ng.git >/dev/null 2>&1
		cd enum4linux-ng
		pip3 install --root-user-action=ignore -r requirements.txt 1>/dev/null
	fi
	}


install_evilportals_wifipineapple() {
	FOLDER=/opt/evilportals
	if [ -d "$FOLDER" ]
	then
		echo "${green}evilportals appears to be installed already.  moving along...${white}"
	else
		echo "${green}Installing Evil Portals for WiFI Pineapple...${white}"
		cd /opt
		git clone https://github.com/kbeflo/evilportals.git >/dev/null 2>&1
	fi
	}


install_stegoVeritas() {
	if ! [ -x "$(command -v stegoveritas)" ]
	then
		echo "${green}Installing stegoVeritas for all of those steganography nerds out there...${white}"
		pip3 install --root-user-action=ignore stegoveritas 1>/dev/null
		stegoveritas_install_deps 1>/dev/null
	else
		echo "${green}stegoVeritas appears to be installed already.  moving along...${white}"
	fi
	}


install_crackmapexec() {
	if ! [ -x "$(command -v crackmapexec)" ]
	then
		echo "${green}Installing CrackMapExec...${white}"
		apt install crackmapexec -y >/dev/null 2>&1
	else
		echo "${green}crackmapexec appears to be installed already.  moving along...${white}"
	fi
	}

snag_random_repos() {
	echo "${green}Setting up SUID3NUM, linuxprivchecker and The Bug Bounty Methodology...${white}"
	cd /opt
#	git clone https://github.com/thelinuxchoice/OSCP-Preparation-Material.git >/dev/null 2>&1
	git clone https://github.com/Anon-Exploiter/SUID3NUM.git >/dev/null 2>&1
	git clone https://github.com/sleventyeleven/linuxprivchecker.git >/dev/null 2>&1
	git clone https://github.com/jhaddix/tbhm.git >/dev/null 2>&1
	}


install_dnstwist() {
	if ! [ -x "$(command -v dnstwist)" ]
	then
		echo "${green}Installing DNSTwist...${white}"
		pip3 install --root-user-action=ignore dnstwist 1>/dev/null
	else
		echo "${green}dnstwist appears to be installed already.  moving along...${white}"
	fi
	}



install_autoenum() {
	FOLDER=/opt/autoenum
	if [ -d "$FOLDER" ]
	then
		echo "${green}autoenum appears to be installed already.  moving along...${white}"
	else
		echo "${green}Installing autoenum...${white}"
		cd /opt
		git clone https://github.com/Gr1mmie/autoenum.git >/dev/null 2>&1
		cd autoenum
		chmod +x autoenum.sh 1>/dev/null
	fi
	}


install_easysploit() {
	if ! [ -x "$(command -v easysploit)" ]
	then
		echo "${green}Installing easysploit...${white}"
		cd /opt
		git clone https://github.com/KALILINUXTRICKSYT/easysploit.git >/dev/null 2>&1
		cd easysploit
		bash installer.sh 1>/dev/null
	else
		echo "${green}easysploit appears to be installed already.  moving along...${white}"
	fi
	}



install_sherlock(){
	FOLDER=/opt/sherlock
	if [ -d "$FOLDER" ]
	then
		echo "${green}sherlock appears to be installed already.  moving along...${white}"
	else
		echo "${green}Installing sherlock...${white}"
		cd /opt
		git clone https://github.com/sherlock-project/sherlock.git >/dev/null 2>&1
		cd sherlock
		pip3 install --root-user-action=ignore -r requirements.txt 1>/dev/null
	fi
	}



install_threader3000() {
	if ! [ -x "$(command -v threader3000)" ]
	then
		echo "${green}Installing threader3000...${white}"
		pip3 install --root-user-action=ignore threader3000 1>/dev/null
	else
		echo "${green}threader3000 appears to be installed already.  moving along...${white}"
	fi
	}


install_locate() {
	if ! [ -x "$(command -v locate)" ]
	then
		echo "${green}Installing locate...${white}"
		apt install locate -y >/dev/null 2>&1
		updatedb
	else
		echo "${green}locate appears to be installed already.  moving along...${white}"
	fi
	}


install_seclists() {
	if ! [ -x "$(command -v seclists)" ]
	then
		echo "${green}Installing SecLists...${white}"
		apt install seclists -y >/dev/null 2>&1
		cat /usr/share/seclists/Discovery/DNS/dns-Jhaddix.txt | head -n -14 > /tmp/clean-jhaddix-dns.txt
		mv /tmp/clean-jhaddix-dns.txt /usr/share/seclists/Discovery/DNS/clean-jhaddix-dns.txt
	else
		git pull >/dev/null 2>&1
		cat /usr/share/seclists/Discovery/DNS/dns-Jhaddix.txt | head -n -14 > /tmp/clean-jhaddix-dns.txt
		mv /tmp/clean-jhaddix-dns.txt /usr/share/seclists/Discovery/DNS/clean-jhaddix-dns.txt
		echo "${green}SecLists appears to be installed already.  moving along...${white}"
	fi
	}


install_dnsdumpster() {
	FOLDER=/opt/dnsdumpster
	if [ -d "$FOLDER" ]
	then
		echo "${green}dnsdumpster appears to be installed already.  moving along...${white}"
	else
		echo "${green}Installing DNSDumpster...${white}"
		cd /opt
		git clone https://github.com/wangoloj/dnsdumpster.git >/dev/null 2>&1
		cd dnsdumpster
		pip3 install --root-user-action=ignore -r requirements.txt 1>/dev/null
	fi
	}

install_github_search() {
	FOLDER=/opt/github-search
	if [ -d "$FOLDER" ]
	then
		echo "${green}github-search appears to be installed already.  moving along...${white}"
	else
		echo "${green}Installing Github_Search...${white}"
		cd /opt
		git clone https://github.com/gwen001/github-search.git >/dev/null 2>&1
		cd github-search
		pip3 install --root-user-action=ignore -r requirements.txt 1>/dev/null
	fi
	}


install_shodan_cli() {
	if ! [ -x "$(command -v shodan)" ]
	then
		echo "${green}Installing Shodan CLI...${white}"
		pip3 install --root-user-action=ignore shodan 1>/dev/null
	else
		echo "${green}shodan appears to be installed already.  moving along...${white}"
	fi
	}



install_interlace() {
	FOLDER=/opt/Interlace
	if [ -d "$FOLDER" ]
	then
		echo "${green}Interlace appears to be installed already.  moving along...${white}"
	else
		echo "${green}Installing Interlace...${white}"
		cd /opt/
		git clone https://github.com/codingo/Interlace.git >/dev/null 2>&1
		cd Interlace
		#pip3 install --root-user-action=ignore -r requirements.txt 1>/dev/null
		python3 setup.py install >/dev/null 2>&1
	fi
	}


install_certspotter() {
	dpkg -s certspotter &>/dev/null
	if [ $? -ne 0 ]
	then
		echo "${green}Installing Certspotter...${white}"
		cd /opt
		git clone https://github.com/SSLMate/certspotter.git >/dev/null 2>&1
		go install software.sslmate.com/src/certspotter/cmd/certspotter@latest 1>/dev/null 2>&1
		mv ~/go/bin/certspotter /opt/certspotter/certspotter 1>/dev/null
		ln -sf /opt/certspotter/certspotter /usr/bin/certspotter 1>/dev/null
	else
		echo "${green}certspotter appears to be installed already.  moving along...${white}"
		cd /opt/certspotter
		rm certspotter
		git pull >/dev/null 2>&1
		go install software.sslmate.com/src/certspotter/cmd/certspotter@latest >/dev/null 2>&1
		mv ~/go/bin/certspotter /opt/certspotter/certspotter 1>/dev/null
	fi
	}



install_cloudbrute() {
	if ! [ -x "$(command -v CloudBrute)" ]
	then
		echo "${green}Installing CloudBrute...${white}"
		cd /opt
		git clone https://github.com/jhaddix/CloudBrute.git >/dev/null 2>&1
		cd CloudBrute
		go build -o CloudBrute main.go >/dev/null 2>&1
		ln -sf /opt/CloudBrute/CloudBrute /usr/bin/CloudBrute 1>/dev/null
	else
		echo "${green}CloudBrute appears to be installed already.  moving along...${white}"
		cd /opt/CloudBrute
		rm CloudBrute
		git pull >/dev/null 2>&1
		go build -o CloudBrute main.go >/dev/null 2>&1
		cd 
	fi
	}



install_gau() {
	if ! [ -x "$(command -v gau)" ]
	then
		echo "${green}Installing gau...${white}"
		cd /opt
		git clone https://github.com/lc/gau.git >/dev/null 2>&1
		cd gau
		go install github.com/lc/gau/v2/cmd/gau@latest >/dev/null 2>&1
		ln -sf /opt/gau/gau /usr/bin/gau 1>/dev/null
	else
		echo "${green}gau appears to be installed already, but lets make sure its updated.${white}"
		currentver=$(gau --version | cut -d " " -f 3)
		latestver=$(curl -s https://api.github.com/repos/lc/gau/releases/latest | grep -oP '"tag_name": "\K(v[\d.]+)' | cut -d "v" -f2)
		
		if [ "$currentver" != "$latestver" ]; then
			echo "${green}Updating gau..."
			cd /opt/gau
			rm gau >/dev/null 2>&1
			rm /usr/bin/ >/dev/null 2>&1
			go install github.com/lc/gau/v2/cmd/gau@latest
			mv ~/go/bin/gau /opt/gau
			ln -s /opt/gau/gau /usr/bin/gau
		else
			echo "${green}Up to date!"
			fi
	fi
	}



install_massdns() {
	if ! [ -x "$(command -v massdns)" ]
	then
		echo "${green}Installing massdns...${white}"
		cd /opt
		git clone https://github.com/blechschmidt/massdns.git >/dev/null 2>&1
		cd massdns
		make 1>/dev/null
		ln -sf /opt/massdns/bin/massdns /usr/bin/massdns 1>/dev/null
	else
		echo "${green}massdns appears to be installed already.  moving along...${white}"
	fi
	}



install_autorecon() {
	if ! [ -x "$(command -v autorecon)" ]
	then
		echo "${green}Installing autorecon...${white}"
		cd /opt
		git clone https://github.com/Tib3rius/AutoRecon.git >/dev/null 2>&1
		cd AutoRecon
		apt install seclists curl enum4linux gobuster nbtscan nikto nmap onesixtyone oscanner smbclient smbmap smtp-user-enum snmp sslscan sipvicious tnscmd10g whatweb wkhtmltopdf -y >/dev/null 2>&1
		python3 -m pip install git+https://github.com/Tib3rius/AutoRecon.git >/dev/null 2>&1
		mv ~/.local/bin/autorecon /usr/bin/autorecon >/dev/null 2>&1
	else
		echo "${green}autorecon appears to be installed already.  moving along...${white}"
	fi
	}



install_hetty() {
	if ! [ -x "$(command -v hetty)" ]
	then
		echo "${green}Installing hetty...${white}"
		cd /opt
		git clone https://github.com/dstotijn/hetty.git >/dev/null 2>&1
		cd hetty
		git checkout $(git describe --tags)
#		chmod +x hetty >/dev/null 2>&1
		ln -sf /opt/hetty/zip/hetty /usr/local/bin/hetty 1>/dev/null
	else
		echo "${green}hetty appears to be installed already.  moving along...${white}"
		echo "${green}checking to see if it is up to date...${white}"

		# Store the current version of hetty on the system
		hettycurver=$(cd /opt/hetty && git describe --tags)
		hettyver=$(echo $hettycurver | cut -d "-" -f1) 
		# Store the latest version of hetty available on GitHub
		hettylatestver=$(curl -s https://api.github.com/repos/dstotijn/hetty/releases/latest | jq -r '.tag_name')

		# Compare the two version numbers
		if [[ $hettyver != $hettylatestver ]]; then
		# Download the latest version
		echo "${green}Does not show you are on the current version, lets fix that...{white}"
		cd /opt/hetty
		LatestVersion=$(curl -s https://api.github.com/repos/dstotijn/hetty/releases/latest | jq -r '.assets[].browser_download_url' | grep "Linux_x" | head -n 1)
		wget $LatestVersion >/dev/null 2>&1
		mkdir zip
		tar -zxvf hetty_0.7.0_Linux*.gz -C zip
		rm hetty_*.gz
		rm /usr/bin/hetty
		ln -sf /opt/hetty/zip/hetty /usr/bin/hetty 1>/dev/null

	else
		echo "${green}hetty is already up-to-date${white}"
	fi

	fi
}


install_atom() {
	if ! [ -x "$(command -v atom)" ]
	then
		echo "${green}Installing Atom...${white}"
		cd /tmp
		wget -qO- https://atom.io/download/deb -O atom.deb >/dev/null 2>&1
		dpkg -i atom.deb >/dev/null 2>&1
		rm atom.deb
		apt -y --fix-broken install >/dev/null 2>&1
	else
		echo "${green}atom appears to be installed already.  moving along...${white}"
	fi
	}



install_gospider() {
	if ! [ -x "$(command -v gospider)" ]
	then
		echo "${green}Installing gospider...${white}"
		cd /opt
		git clone https://github.com/jaeles-project/gospider >/dev/null 2>&1
		cd gospider
		go build >/dev/null 2>&1
		cp gospider /usr/bin/
	else
		echo "${green}gospider appears to be installed already.  moving along...${white}"
	fi
	}


install_phprevshell() {
	FOLDER=/opt/php-reverse-shell
	if [ -d "$FOLDER" ]
	then
		echo "${green}php-reverse-shell seems to already exist.  moving along...${white}"
	else
		echo "${green}Setting up php-reverse-shell...${white}"
		cd /opt/
		sudo git clone https://github.com/pentestmonkey/php-reverse-shell >/dev/null 2>&1
	fi
}


install_instashell() {
	FOLDER=/opt/instashell
	if [ -d "$FOLDER" ]
	then
		echo "${green}instashell appears to be installed already.  moving along...${white}"
	else
		echo "${green}Installing instashell...${white}"
		cd /opt
		git clone https://github.com/NathanLundner/instashell >/dev/null 2>&1
	fi
	}


install_wesng(){
	FOLDER=/opt/wesng
	if [ -d "$FOLDER" ]
	then
		echo "${green}wesng appears to be installed already.  moving along...${white}"
	else
		echo "${green}Installing wesng...${white}"
		cd /opt
		git clone https://github.com/bitsadmin/wesng >/dev/null 2>&1
	fi
	}


install_metabigor() {
if ! [ -x "$(command -v metabigor)" ]
	then
		echo "${green}Installing metabigor...${white}"
		cd /opt
		git clone https://github.com/j3ssie/metabigor >/dev/null 2>&1
		cd metabigor
		#go get -u github.com/j3ssie/metabigor >/dev/null 2>&1
		#cd ~/go/src/github.com/j3ssie/metabigor
		go build >/dev/null 2>&1
		#cp metabigor /opt/metabigor/
		ln -sf /opt/metabigor/metabigor /usr/bin/metabigor
	else
			echo "${green}metabigor appears to be installed already.  moving along...${white}"
		fi
		}


install_asn() {
if ! [ -x "$(command -v asn)" ]
	then
		echo "${green}Installing asn...${white}"
		cd /opt
		git clone https://github.com/nitefood/asn >/dev/null 2>&1
		ln -sf /opt/asn/asn /usr/bin/asn
	else
		echo "${green}asn appears to be installed already.  moving along...${white}"
	fi
	}


install_mindmaster() {
	if ! [ -x "$(command -v mindmaster)" ]
	then
		echo "${green}Installing mindmaster...${white}"
		cd ~/Downloads
		mmaster=$(wget -qO- https://www.edrawsoft.com/download-mindmaster.html | grep ".deb" | awk -F "<a href=" '{print $2}' | cut -d " " -f 1 | sed 's/"//g') >/dev/null 2>&1
		wget $mmaster >/dev/null 2>&1
		dpkg -i edrawmind-*.deb >/dev/null 2>&1
		rm edrawmind-*.deb
	else
		echo "${green}mindmaster appears to be installed already.  moving along...${white}"
	fi
	}



install_pspy() {
	FILE=/opt/pspy/binaries/pspy32s
	if [ -f "$FILE" ]
	then
		echo "${green}pspy appears to be installed already.  moving along...${white}"
	else
		echo "${green}Installing pspy${white}"
		cd /opt
		git clone https://github.com/DominicBreuker/pspy >/dev/null 2>&1
		mkdir -p pspy/binaries
		echo "${green}Snagging pspy binaries to /opt/pspy/binaries...${white}"
		wget -qO- https://github.com/DominicBreuker/pspy | grep "download/" | awk -F "a href=" '{print $2}' | awk -F ">" '{print $1}' | sed 's/"//g'| sed 's/^/wget /g' > /opt/pspy/binaries/snagem.sh
		cd /opt/pspy/binaries
		bash snagem.sh >/dev/null 2>&1
		rm snagem.sh
	fi

	}
	


install_feroxbuster() {
	if ! [ -x "$(command -v feroxbuster)" ];then
		echo "${green}Installing feroxbuster...${white}"
		apt install feroxbuster -y >/dev/null 2>&1
	else
		echo "${green}feroxbuster seems its installed already, lets see if it needs updates...${white}"
		current_ver=$(feroxbuster -V | cut -d " " -f2)
		latest_ver=$(curl -s https://api.github.com/repos/epi052/feroxbuster/releases/latest | jq -r '.tag_name' | sed 's/v//')
		
		if [ "$current_ver" != "$latest_ver" ]; then
		echo "${green}A newer version of feroxbuster is available. Updating...${white}"
		apt upgrade feroxbuster -y >/dev/null 2>&1
	else
		echo "${green}Feroxbuster is up to date.${white}"
	fi
fi
	
}





check_arg () {
  if [ "$1" == "" ]
  then
    skip=0
  else
    case $1 in
    --skip) skip=1 ;;
    esac
    fi
  }



check_arg "$1"
install_jq
fix_sources
install_docker
install_go
install_pip
install_pip3
install_terminator
pimpmykali $skip
install_ffuf
#install_p0wny_shell
install_dirsearch
install_PEAS
install_linenum
install_aquatone
install_rsg
install_nmap_vulners
install_gtfoblookup
install_navi
install_tom_httprobe
install_tom_waybackurls
install_tom_unfurl
install_tom_fff
install_tom_hacks
install_nahamsec_stuff
install_neo4j
install_bloodhound
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
install_dnstwist
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
install_massdns
install_autorecon
install_hetty
#install_atom Atom is no longer supported
install_gospider
install_phprevshell
install_instashell
install_wesng
install_metabigor
#install_mindmaster Not free
install_pspy
install_feroxbuster
sleep 2
apt -y --fix-broken install >/dev/null 2>&1

echo ""
echo ""
echo ""
echo ""
echo ""
echo ""
hackthe=$(base64 -d <<< "H4sIAAAAAAAAA21M0RUAIQj6b4pYgy/2n+pKKat3lQYIttbHkVQtfgMdox/NgrwESzVAxjwqBjz2
zCNvgVlOSJusfNkB5ooBZkMBwqmpbJLzyx75ziiegPGskF7Ay54etg/NTlOxTgEAAA==" | gunzip )

signature=$(base64 -d <<< "H4sIAAAAAAAAA+NSwApKMlIVUouLU/NKMhNziq0UknIy81IKgNzU4pLUIi7smnACLgCGungsZgAA
AA==" | gunzip )

planet=$(base64 -d <<< "H4sIAAAAAAAAA7VLuRHAMAjrmQItkAGovP9U4fXJSdrAHRJ6VGdWTRJWWoizJtMoSm1MBi/Bl5ww
Ae4iMymPkFtOEcDw0XX5JImefpAdoq7aRrPLAurxt+2k9amJcPnXkRuVRIOPmAEAAA==" | gunzip )

echo -e "${red}$hackthe${white}"
echo -e "$grn$signature${white}"
echo -e "${red}$planet${white}"
