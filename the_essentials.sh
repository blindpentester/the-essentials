#!/bin/bash
#
# Simple script to reach out and get some toys for Kali Linux 2020.X to help collect recon/bug bounty/fuzzing tools
#
#
# Usage:
# ./the_essentials.sh

red=$'\e[1;31m'
grn=$'\e[1;32m'
blu=$'\e[1;34m'
mag=$'\e[1;35m'
cyn=$'\e[1;36m'
white=$'\e[0m'

skip=0    # Add skip=0 up here by colors

if [ "$EUID" -ne 0 ]
	then echo -e $grn"\n\n Script must be run with sudo ./the_essentials.sh or as root \n"$grn
       exit
fi




fix_sources() {
	echo $grn"Fixing sources..."$white
	echo "deb http://http.kali.org/kali kali-rolling main non-free contrib" > /etc/apt/sources.list
	echo "deb-src http://http.kali.org/kali kali-rolling main non-free contrib" >> /etc/apt/sources.list
	apt update >/dev/null 2>&1
	}


install_docker() {
if ! [ -x "$(command -v docker)" ]
then
	echo $grn"Installing docker..."$white
	curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add - >/dev/null 2>&1
	echo 'deb [arch=amd64] https://download.docker.com/linux/debian buster stable' | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null 2>&1
	sudo apt-get update >/dev/null 2>&1
	apt-get install docker-ce -y >/dev/null 2>&1

else
	echo $grn"docker appears to be installed already.  moving along..."$white
	apt-get remove docker docker-engine docker.io >/dev/null 2>&1
	apt-get install docker-ce -y >/dev/null 2>&1

	fi

	}



install_go() {
	if ! [ -x "$(command -v go)" ]
    then
        echo $grn"Installing golang..."$white
        apt install golang -y >/dev/null 2>&1
    else
        echo $grn"golang already installed. move along..."$white
    fi
	}


install_pip() {
    if ! [ -x "$(command -v pip)" ]
    then
        echo $grn"Installing pip..."$white
        curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py >/dev/null 2>&1
        python get-pip.py >/dev/null 2>&1
        rm get-pip.py
    else
        echo $grn"python-pip already installed. move along..."$white
    fi

        }


install_pip3() {
	if ! [ -x "$(command -v pip3)" ]
	then
		echo $grn"Installing pip3..."$white
		apt install python3-pip -y >/dev/null 2>&1
	else
		echo $grn"pip3 already installed, move along..."$white
	fi

	}


install_terminator() {
	if ! [ -x "$(command -v terminator)" ]
	then
		echo $grn"Installing Terminator..."$white
		apt install terminator -y >/dev/null 2>&1
	else
		echo $grn"Terminator already installed, move along..."$white
	fi
	}






pimpmykali() {
  if [ $skip = 0 ]  # this HAS to be $skip = 0 no -ne or anything fancy
  then
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
        else
          echo "skipping pimpmykali.sh --skippimp was used"
    fi
  }



install_ffuf() {
	if ! [ -x "$(command -v ffuf)" ]
	then
		echo $grn"Installing ffuf..."$white
		cd /opt
		git clone https://github.com/ffuf/ffuf.git >/dev/null 2>&1
		cd ffuf
		go build 1> /dev/null
		ln -sf /opt/ffuf/ffuf /usr/bin/ffuf 1> /dev/null
	else
		echo $grn"ffuf already exists, move along..."$white
	fi
	}



install_p0wny_shell() {
	FILE=/opt/p0wny-shell/README.md
	if [ -f "$FILE" ]
	then
		echo $grn"p0wny-shell exists already, moving on to next item..."$white
	else
		echo $grn"Setting up p0wny-shell..."$white
		cd /opt/
		git clone https://github.com/flozz/p0wny-shell.git >/dev/null 2>&1
	fi
	}


install_dirsearch() {
	if ! [ -x "$(command -v dirsearch)" ]
	then
		echo $grn"Installing dirsearch..."$white
		cd /opt/
		git clone https://github.com/maurosoria/dirsearch.git >/dev/null 2>&1
		cd dirsearch
		ln -sf /opt/dirsearch/dirsearch.py /usr/bin/dirsearch >/dev/null 2>&1
	else
		echo $grn"dirsearch appears to be installed already.  moving along..."$white
	fi
	}



install_PEAS() {
	FOLDER=/opt/privilege-escalation-awesome-scripts-suite
	if [ -d "$FOLDER" ]
	then
		echo $grn"Privilege Escalation Awesome Scripts Suite already exists.  Skipping to next item..."$white
	else
		echo $grn"Installing Privilege Escalation Awesome Scripts Suite..."$white
		cd /opt/
		git clone https://github.com/carlospolop/privilege-escalation-awesome-scripts-suite.git >/dev/null 2>&1
	fi
	}

install_linenum() {
	FOLDER=/opt/LinEnum
	if [ -d "$FOLDER" ]
	then
		echo $grn"LinEnum already exists.  Skipping to next item..."$white
	else
		cd /opt
		git clone https://github.com/rebootuser/LinEnum.git >/dev/null 2>&1
	fi
	}



install_aquatone() {
	if ! [ -x "$(command -v aquatone)" ]
	then
		echo $grn"Installing aquatone..."$white
		cd /opt/
		git clone https://github.com/michenriksen/aquatone.git >/dev/null 2>&1
		cd aquatone
		go get github.com/michenriksen/aquatone 1> /dev/null
		mv ~/go/bin/aquatone . 1> /dev/null
		ln -sf /opt/aquatone/aquatone /usr/bin/aquatone >/dev/null 2>&1
	else
		echo $grn"aquatone appears to be installed already.  moving along..."$white
	fi
	}



install_rsg() {
	if ! [ -x "$(command -v rsg)" ]
	then
		echo $grn"Installing Reverse Shell Generator..."$white
		cd /opt/
		git clone https://github.com/mthbernardes/rsg.git >/dev/null 2>&1
		cd rsg
		sh install.sh 1> /dev/null
	else
		echo $grn"rsg already installed.  moving along..."$white
	fi
	}



install_nmap_vulners() {
	FOLDER=/opt/nmap-vulners
	if [ -d "$FOLDER" ]
	then
		echo $grn"nmap vulners already exists.  Skipping to next item."$white
	else
		echo $grn"Installing NMAP Vulners Scripts..."$white
		cd /opt
		git clone https://github.com/vulnersCom/nmap-vulners.git >/dev/null 2>&1
		cd nmap-vulners
		cp http-vulners-regex.nse /usr/share/nmap/scripts/ 1> /dev/null
		cp http-vulners-regex.json /usr/share/nmap/nselib/data/ 1> /dev/null
		cp http-vulners-paths.txt /usr/share/nmap/nselib/data/ 1> /dev/null
		wget https://svn.nmap.org/nmap/scripts/clamav-exec.nse -O /usr/share/nmap/scripts/clamav-exec.nse >/dev/null 2>&1
		nmap --script-updatedb 1> /dev/null
	fi
	}


 install_gtfoblookup() {
	FOLDER=/opt/GTFOBLookup
	if [ -d "$FOLDER" ]
	then
		echo $grn"$FOLDER already exists.  Skipping to next item..."$white
	else
		echo $grn"Installing GTFOBLookup..."$white
		cd /opt/
		git clone https://github.com/nccgroup/GTFOBLookup.git >/dev/null 2>&1
		cd GTFOBLookup
		pip3 install -r requirements.txt 1> /dev/null
		python3 gtfoblookup.py update 1> /dev/null
	fi
	}


install_navi() {
	FOLDER=/opt/navi
	if [ -d "$FOLDER" ]
	then
		echo $grn"navi already exists.  Skipping to next item."$white
	else
		echo $grn"Installing NAVI and FZF..."$white
		cd /opt/
		git clone https://github.com/denisidoro/navi.git >/dev/null 2>&1
		cd navi
		# Installing Dependency FZF
		apt install fzf >/dev/null 2>&1
		bash <(curl -sL https://raw.githubusercontent.com/denisidoro/navi/master/scripts/install) >/dev/null 2>&1
	fi
	}



install_tom_httprobe() {
	if ! [ -x "$(command -v httprobe)" ]
	then
		echo $grn"Installing httprobe..."$white
		cd /opt/
		git clone https://github.com/tomnomnom/httprobe.git >/dev/null 2>&1
		cd httprobe
		go build 1> /dev/null
		ln -sf /opt/httprobe/httprobe /usr/bin/httprobe >/dev/null 2>&1
	else
		echo $grn"httprobe appears to be installed already.  moving along..."$white
	fi

	}


install_tom_waybackurls() {
	if ! [ -x "$(command -v waybackurls)" ]
	then
		echo $grn"Installing waybackurls..."$white
		cd /opt/
		git clone https://github.com/tomnomnom/waybackurls.git >/dev/null 2>&1
		cd waybackurls
		go build 1> /dev/null
		ln -sf /opt/waybackurls/waybackurls /usr/bin/waybackurls >/dev/null 2>&1
	else
		echo $grn"waybackurls appears to be installed already.  moving along..."$white
	fi
	}


install_tom_unfurl() {
	if ! [ -x "$(command -v unfurl)" ]
	then
		echo $grn"Installing UnFURL..."$white
		cd /opt
		git clone https://github.com/tomnomnom/unfurl.git >/dev/null 2>&1
		cd unfurl
		go get -u github.com/tomnomnom/unfurl 1> /dev/null
		mv /root/go/bin/unfurl /opt/unfurl/ 1> /dev/null
		ln -sf /opt/unfurl/unfurl /usr/bin/unfurl >/dev/null 2>&1
	else
		echo $grn"unfurl appears to be installed already.  moving along..."$white
	fi
	}



install_tom_fff() {
	if ! [ -x "$(command -v fff)" ]
	then
		echo $grn"Installing fff..."$white
		cd /opt
		git clone https://github.com/tomnomnom/fff.git >/dev/null 2>&1
		cd fff
		go build >/dev/null 2>&1
		ln -sf /opt/fff/fff /usr/bin/fff >/dev/null 2>&1
	else
		echo $grn"fff appears to be installed already.  moving along..."$white
	fi

	}



install_tom_hacks() {
	FOLDER=/opt/hacks
	if [ -d "$FOLDER" ]
	then
		echo $grn"hacks repo appears to be installed already.  moving along..."$white
	else
		echo $grn"Installing hacks repository..."$white
		cd /opt
		git clone https://github.com/tomnomnom/hacks.git >/dev/null 2>&1
	fi
	}


install_nahamsec_stuff() {
	echo $grn"Installing crtdnstry, jq and rename..."$white
	# cd /opt
	# git clone https://github.com/nahamsec/lazyrecon.git >/dev/null 2>&1
	# cd lazyrecon
	# ln -sf /opt/lazyrecon/lazyrecon.sh /usr/share/lazyrecon 1> /dev/null

	# Modifying lazyrecon to work with current downloaded/installed files from this script
	# sed -i 's/~\/tools/\/opt/g' lazyrecon.sh 1> /dev/null
	# sed -i 's/python \/opt\/Sublist3r\/sublist3r.py/sublist3r/g' lazyrecon.sh 1> /dev/null
	# sed -i 's/\/opt\/SecLists/\/usr\/share\/seclists/g' lazyrecon.sh 1> /dev/null


	cd /opt
	git clone https://github.com/nahamsec/crtndstry.git >/dev/null 2>&1
	cd /opt
	apt install jq -y >/dev/null 2>&1
	apt install rename -y >/dev/null 2>&1
	}


install_neo4j() {
	if ! [ -x "$(command -v neo4j)" ]
	then
		echo $grn"Installing neo4j..."$white
		apt install neo4j -y >/dev/null 2>&1
	else
		echo $grn"neo4j appears to be installed already.  moving along..."$white
	fi

	}


install_bloodhound() {
	if ! [ -x "$(command -v bloodhound)" ]
	then
		echo $grn"Installing bloodhound..."$white
		apt install bloodhound -y >/dev/null 2>&1
	else
		echo $grn"bloodhound appears to be installed already.  moving along..."$white
	fi

	}



install_sublist3r() {
	if ! [ -x "$(command -v sublist3r)" ]
	then
		echo $grn"Installing sublist3r"$white
		apt install sublist3r -y >/dev/null 2>&1
	else
		echo $grn"sublist3r appears to be installed already.  moving along..."$white
	fi
	}


installing_asnlookup() {
	echo $grn"Installing asnlookup..."$white
	FOLDER=/opt/asnlookup
	if [ -d "$FOLDER" ]
	then
		echo $grn"asnlookup is already setup.  Skipping to next item."$white
	else
		cd /opt
		git clone https://github.com/yassineaboukir/asnlookup.git >/dev/null 2>&1
		cd asnlookup
		pip3 install -r requirements.txt 1> /dev/null
	fi
	}


install_evil_winrm() {
	if ! [ -x "$(command -v evil-winrm)" ]
	then
		echo $grn"Installing Evil-WinRM..."$white
		gem install evil-winrm 1> /dev/null
	else
		echo $grn"evil-winrm appears to be installed already.  moving along..."$white
	fi
	}


install_powercat() {
	FOLDER=/opt/powercat
	if [ -d "$FOLDER" ]
	then
		echo $grn"powercat is already setup..."$white
	else
		echo $grn"Installing Powercat..."$white
		cd /opt
		git clone https://github.com/besimorhino/powercat.git >/dev/null 2>&1
	fi
	}


install_more_wordlists() {
	FOLDER=/opt/Wordlists
	if [ -d "$FOLDER" ]
	then
		echo $grn"Wordlists is already setup..."$white
	else
		echo $grn"Getting more wordlists..."$white
		cd /opt
		git clone https://github.com/ZephrFish/Wordlists.git >/dev/null 2>&1
	fi
	}


install_gobuster() {
	if ! [ -x "$(command -v gobuster)" ]
	then
		echo $grn"Installing GoBuster..."$white
		apt install gobuster -y >/dev/null 2>&1
	else
		echo $grn"gobuster appears to be installed already.  moving along..."$white

	fi
	}


install_recursivegobuster() {
	FOLDER=/opt/recursive-gobuster
	if [ -d "$FOLDER" ]
	then
		echo $grn"recursive-gobuster appears to be installed already.  moving along..."$white
	else
		echo $grn"Installing recursive-gobuster..."$white
		cd /opt/
		git clone https://github.com/epi052/recursive-gobuster.git >/dev/null 2>&1
	fi
	}


install_enum4linux_ng() {
	FOLDER=/opt/enum4linux-ng
	if [ -d "$FOLDER" ]
	then
		echo $grn"enum4linux-ng appears to be installed already.  moving along..."$white
	else
		echo $grn"Installing enum4linux-ng..."$white
		cd /opt
		git clone https://github.com/cddmp/enum4linux-ng.git >/dev/null 2>&1
		cd enum4linux-ng
		pip3 install -r requirements.txt 1> /dev/null
	fi
	}


install_evilportals_wifipineapple() {
	FOLDER=/opt/evilportals
	if [ -d "$FOLDER" ]
	then
		echo $grn"evilportals appears to be installed already.  moving along..."$white
	else
		echo $grn"Installing Evil Portals for WiFI Pineapple..."$white
		cd /opt
		git clone https://github.com/kbeflo/evilportals.git >/dev/null 2>&1
	fi
	}


install_stegoVeritas() {
	if ! [ -x "$(command -v stegoveritas)" ]
	then
		echo $grn"Installing stegoVeritas for all of those steganography nerds out there..."$white
		pip3 install stegoveritas 1> /dev/null
		stegoveritas_install_deps 1> /dev/null
	else
		echo $grn"stegoVeritas appears to be installed already.  moving along..."$white
	fi
	}


install_crackmapexec() {
	if ! [ -x "$(command -v crackmapexec)" ]
	then
		echo $grn"Installing CrackMapExec..."$white
		apt install crackmapexec -y >/dev/null 2>&1
	else
		echo $grn"crackmapexec appears to be installed already.  moving along..."$white
	fi
	}

snag_random_repos() {
	echo $grn"Setting up OSCP Prep Material, SUID3NUM, linuxprivchecker and The Bug Bounty Methodology..."$white
	cd /opt
	git clone https://github.com/thelinuxchoice/OSCP-Preparation-Material.git >/dev/null 2>&1
	git clone https://github.com/Anon-Exploiter/SUID3NUM.git >/dev/null 2>&1
	git clone https://github.com/sleventyeleven/linuxprivchecker.git >/dev/null 2>&1
	git clone https://github.com/jhaddix/tbhm.git >/dev/null 2>&1
	}


install_dnstwist() {
	if ! [ -x "$(command -v dnstwist)" ]
	then
		echo $grn"Installing DNSTwist..."$white
		pip3 install dnstwist 1> /dev/null
	else
		echo $grn"dnstwist appears to be installed already.  moving along..."$white
	fi
	}

install_spoofcheck() {
	FOLDER=/opt/spoofcheck
	if [ -d "$FOLDER" ]
	then
		echo $grn"spoofcheck appears to be installed already.  moving along..."$white
	else
		echo $grn"Installing spoofcheck..."$white
		cd /opt
		git clone https://github.com/BishopFox/spoofcheck.git >/dev/null 2>&1
		cd spoofcheck
		pip install -r requirements.txt 1> /dev/null
	fi
	}

install_autoenum() {
	FOLDER=/opt/autoenum
	if [ -d "$FOLDER" ]
	then
		echo $grn"autoenum appears to be installed already.  moving along..."$white
	else
		echo $grn"Installing autoenum..."$white
		cd /opt
		git clone https://github.com/Gr1mmie/autoenum.git >/dev/null 2>&1
		cd autoenum
		chmod +x autoenum.sh 1> /dev/null
	fi
	}


install_easysploit() {
	if ! [ -x "$(command -v easysploit)" ]
	then
		echo $grn"Installing easysploit..."$white
		cd /opt
		git clone https://github.com/KALILINUXTRICKSYT/easysploit.git >/dev/null 2>&1
		cd easysploit
		bash installer.sh 1> /dev/null
	else
		echo $grn"easysploit appears to be installed already.  moving along..."$white
	fi
	}



install_sherlock(){
	FOLDER=/opt/sherlock
	if [ -d "$FOLDER" ]
	then
		echo $grn"sherlock appears to be installed already.  moving along..."$white
	else
		echo $grn"Installing sherlock..."$white
		cd /opt
		git clone https://github.com/sherlock-project/sherlock.git >/dev/null 2>&1
		cd sherlock
		pip3 install -r requirements.txt 1> /dev/null
	fi
	}



install_threader3000() {
	if ! [ -x "$(command -v threader3000)" ]
	then
		echo $grn"Installing threader3000..."$white
		pip3 install threader3000 1> /dev/null
	else
		echo $grn"threader3000 appears to be installed already.  moving along..."$white
	fi
	}


install_locate() {
	if ! [ -x "$(command -v locate)" ]
	then
		echo $grn"Installing locate..."$white
		apt install locate -y >/dev/null 2>&1
		updatedb 1> /dev/null
	else
		echo $grn"locate appears to be installed already.  moving along..."$white
	fi
	}


install_seclists() {
	if ! [ -x "$(command -v seclists)" ]
	then
		echo $grn"Installing SecLists..."$white
		apt install seclists -y >/dev/null 2>&1
		cat /usr/share/seclists/Discovery/DNS/dns-Jhaddix.txt | head -n -14 > /tmp/clean-jhaddix-dns.txt
		mv /tmp/clean-jhaddix-dns.txt /usr/share/seclists/Discovery/DNS/clean-jhaddix-dns.txt
	else
		cat /usr/share/seclists/Discovery/DNS/dns-Jhaddix.txt | head -n -14 > /tmp/clean-jhaddix-dns.txt
		mv /tmp/clean-jhaddix-dns.txt /usr/share/seclists/Discovery/DNS/clean-jhaddix-dns.txt
		echo $grn"SecLists appears to be installed already.  moving along..."$white
	fi
	}


install_dnsdumpster() {
	FOLDER=/opt/dnsdumpster
	if [ -d "$FOLDER" ]
	then
		echo $grn"dnsdumpster appears to be installed already.  moving along..."$white
	else
		echo $grn"Installing DNSDumpster..."$white
		cd /opt
		git clone https://github.com/wangoloj/dnsdumpster.git >/dev/null 2>&1
		cd dnsdumpster
		pip3 install -r requirements.txt 1> /dev/null
	fi
	}


install_github_search() {
	FOLDER=/opt/github-search
	if [ -d "$FOLDER" ]
	then
		echo $grn"github-search appears to be installed already.  moving along..."$white
	else
		echo $grn"Installing Github_Search..."$white
		cd /opt
		git clone https://github.com/gwen001/github-search.git >/dev/null 2>&1
		cd github-search
		pip3 install -r requirements3.txt 1> /dev/null
	fi
	}


install_shodan_cli() {
	if ! [ -x "$(command -v shodan)" ]
	then
		echo $grn"Installing Shodan CLI..."$white
		pip3 install shodan 1> /dev/null
	else
		echo $grn"shodan appears to be installed already.  moving along..."$white
	fi
	}



install_interlace() {
	FOLDER=/opt/Interlace
	if [ -d "$FOLDER" ]
	then
		echo $grn"Interlace appears to be installed already.  moving along..."$white
	else
		echo $grn"Installing Interlace..."$white
		cd /opt/
		git clone https://github.com/codingo/Interlace.git >/dev/null 2>&1
		cd Interlace
		python3 setup.py install 1> /dev/null
	fi
	}


install_certspotter() {
	if ! [ -x "$(command -v certspotter)" ]
	then
		echo $grn"Installing Certspotter..."$white
		cd /opt
		git clone https://github.com/SSLMate/certspotter.git >/dev/null 2>&1
		go get software.sslmate.com/src/certspotter/cmd/certspotter 1> /dev/null
		mv ~/go/bin/certspotter /opt/certspotter/certspotter 1> /dev/null
		ln -sf /opt/certspotter/certspotter /usr/bin/certspotter 1> /dev/null
	else
		echo $grn"certspotter appears to be installed already.  moving along..."$white
	fi
	}



install_cloudbrute() {
	if ! [ -x "$(command -v CloudBrute)" ]
	then
		echo $grn"Installing CloudBrute..."$white
		cd /opt
		git clone https://github.com/jhaddix/CloudBrute.git >/dev/null 2>&1
		cd CloudBrute
		go build -o CloudBrute main.go >/dev/null 2>&1
		ln -sf /opt/CloudBrute/CloudBrute /usr/bin/CloudBrute 1> /dev/null
	else
		echo $grn"CloudBrute appears to be installed already.  moving along..."$white
	fi
	}



install_gau() {
	if ! [ -x "$(command -v gau)" ]
	then
		echo $grn"Installing gau..."$white
		cd /opt
		git clone https://github.com/lc/gau.git >/dev/null 2>&1
		cd gau
		go build -o gau >/dev/null 2>&1
		ln -sf /opt/gau/gau /usr/bin/gau 1> /dev/null
	else
		echo $grn"gau appears to be installed already.  moving along..."$white
	fi
	}



install_massdns() {
	if ! [ -x "$(command -v massdns)" ]
	then
		echo $grn"Installing massdns..."$white
		cd /opt
		git clone https://github.com/blechschmidt/massdns.git >/dev/null 2>&1
		cd massdns
		make 1> /dev/null
		ln -sf /opt/massdns/bin/massdns /usr/bin/massdns 1> /dev/null
	else
		echo $grn"massdns appears to be installed already.  moving along..."$white
	fi
	}



install_autorecon() {
	if ! [ -x "$(command -v autorecon)" ]
	then
		echo $grn"Installing autorecon..."$white
		cd /opt
		git clone https://github.com/Tib3rius/AutoRecon.git >/dev/null 2>&1
		cd AutoRecon
		apt install seclists curl enum4linux gobuster nbtscan nikto nmap onesixtyone oscanner smbclient smbmap smtp-user-enum snmp sslscan sipvicious tnscmd10g whatweb wkhtmltopdf -y >/dev/null 2>&1
		python3 -m pip install git+https://github.com/Tib3rius/AutoRecon.git >/dev/null 2>&1
		mv ~/.local/bin/autorecon /usr/bin/autorecon >/dev/null 2>&1
	else
		echo $grn"autorecon appears to be installed already.  moving along..."$white
	fi
	}



install_hetty() {
	if ! [ -x "$(command -v hetty)" ]
	then
		echo $grn"Installing hetty..."$white
		cd /opt
		git clone https://github.com/dstotijn/hetty.git >/dev/null 2>&1
		cd hetty
		hetty=$(wget -qO- https://github.com/dstotijn/hetty/releases | grep "Linux_x86" | awk -F "href=" '{print $2}' | awk -F "rel=" '{print $1}' | head -n 1 | sed 's/"//g' | sed 's/^/https:\/\/github.com/') 1> /dev/null
		wget $hetty -O /tmp/hetty >/dev/null 2>&1
		tar xvfz /tmp/hetty* -C /opt/hetty 1> /dev/null
		cd /opt/hetty/
		rm -rf /tmp/hetty 1> /dev/null
		ln -sf /opt/hetty/hetty /usr/bin/hetty 1> /dev/null
	else
		echo $grn"hetty appears to be installed already.  moving along..."$white
	fi
	}


install_atom() {
	if ! [ -x "$(command -v atom)" ]
	then
		echo $grn"Installing Atom..."$white
		cd /tmp
		wget -qO- https://atom.io/download/deb -O atom.deb >/dev/null 2>&1
		dpkg -i atom.deb >/dev/null 2>&1
		rm atom.deb
	else
		echo $grn"atom appears to be installed already.  moving along..."$white
	fi
	}


install_ciphey() {
	if ! [ -x "$(command -v ciphey)" ]
	then
		echo $grn"Installing ciphey..."$white
		pip3 install ciphey >/dev/null 2>&1
	else
		echo $grn"ciphey appears to be installed already.  moving along..."$white
	fi

	}

install_gospider() {
	if ! [ -x "$(command -v gospider)" ]
	then
		echo $grn"Installing gospider..."$white
		cd /opt
		git clone https://github.com/jaeles-project/gospider >/dev/null 2>&1
		cd gospider
		go build >/dev/null 2>&1
		cp gospider /usr/bin/
	else
		echo $grn"gospider appears to be installed already.  moving along..."$white
	fi
}

install_instashell() {
	FOLDER=/opt/instashell
	if [ -d "$FOLDER" ]
	then
		echo $grn"instashell appears to be installed already.  moving along..."$white
	else
		echo $grn"Installing instashell..."$white
		cd /opt
		git clone https://github.com/NathanLundner/instashell >/dev/null 2>&1
fi
}


install_wesng(){
FOLDER=/opt/wesng
if [ -d "$FOLDER" ]
then
	echo $grn"wesng appears to be installed already.  moving along..."$white
else
	echo $grn"Installing wesng..."$white
	cd /opt
	git clone https://github.com/bitsadmin/wesng
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
fix_sources
install_docker
install_go
install_pip
install_pip3
install_terminator
pimpmykali $skip
install_ffuf
install_p0wny_shell
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
install_massdns
install_autorecon
install_hetty
install_atom
install_ciphey
install_gospider
install_instashell
install_wesng
sleep 2




clear
echo "            Holy crap!!!  It's over!  FREEEEEEDOOOOOMMMMEEE!"
echo "                   Now go forth and always remember..."
echo $red" _                _      _   _                  _                  _   "
echo "| |__   __ _  ___| | __ | |_| |__   ___   _ __ | | __ _ _ __   ___| |_ "
echo "| '_ \ / _\` |/ __| |/ / | __| '_ \ / _ \ | '_ \| |/ _\` | '_ \ / _ \ __|"
echo "| | | | (_| | (__|   <  | |_| | | |  __/ | |_) | | (_| | | | |  __/ |_ "
echo "|_| |_|\__,_|\___|_|\_\  \__|_| |_|\___| | .__/|_|\__,_|_| |_|\___|\__|"
echo "                        $grn the-essentials $red |_| $grn blindpentester   "$white
