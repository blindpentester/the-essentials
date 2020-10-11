# the-essentials v0.02  
A script that I made to get the essential tools I use for various reasons on Kali Linux.<br /><br />
![HackThePlanet](https://i.ibb.co/5YmrMHZ/htp.pngZ)    

## Usage:  
    cd /opt  
    sudo git clone https://github.com/blindpentester/the-essentials.git  
    cd the-essentials  
    sudo ./the_essentials.sh (add --skip to bypass pimpmykali)  
    
  
### Various Fixes:  
Fixing sources in /etc/apt/sources.list  
NMAP clamav-exec.nse  
python-pip  
python3-pip  

### Installing the following items:  
* docker    
* golang  
* python-pip  
* python3-pip  
* terminator  
* "pimpmykali" from https://github.com/Dewalt-arch/pimpmykali  
* ffuf  
* p0wny-shell  
* dirsearch  
* privilege-escalation-awesome-scripts-suite  
* LinEnum  
* aquatone  
* Reverse Shell Generator  
* nmap vulners  
* gtfoblookup  
* navi  
* httprobe  
* waybackurls  
* unfurl  
* fff  
* crtndstry  
* neo4j & Bloodhound  
* SharpHound  
* sublist3r  
* asnlookup  
* Evil-WinRM  
* Powercat  
* Snagging more Wordlists  
* gobuster  
* recursive-gobuster  
* evilportals (WiFi Pineapple Evil Portals)  
* stegoVertias  
* CrackMapExec  
* dnstwist  
* spoofcheck  
* autoenum  
* easysploit  
* sherlock  
* threader3000  
* locate  
* seclists  
* dnsdumpster  
* shodan cli  
* Interlace  
* certspotter  
* cloudbrute  
* gau   
* massdns  
* AutoRecon  
* hetty  
* Atom 
* ciphey  
* gospider  
* php-reverse-shell
* instashell  
* wesng  
  
## v0.02
* Checks for installs and will move to the next if it sees file/folder exists already.  This way it will only add the items that you currently don't have or will skip and continue through.
    * --skip option added to bypass pimpmykali and continue with installing tools
  
  
## v0.01  
* initial script was set to run at new VM image.  Not intended to run multiple times.  Very rough draft.  
* installed tools but did not check if they existed already  
  
  
## Things to fix  
* Would like to eventually have a menu option to go through and skip anything that the users would want to go past.   
* I am sure more things will arise.  
  
  
