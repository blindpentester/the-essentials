# the-essentials v0.03  
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
* Runs a check on repos that are already in /opt and updates them all with "git pull" requests
* jq  
    * if installed will run apt upgrade for it  
* fix sources  
* docker  
* go  
* python-pip  
* python3-pip  
* terminator  
* pimpmykali  
* ffuf  
    * if installed will perform version check to auto upgrade
* dirsearch  
    * if installed will perform version check to auto upgrade
* PEASS - updated version of "privilege-escalation-awesome-scripts-suite"  
    * also downloads their precompiled binaries for ease of use  
* LinEnum  
* aquatone  
    * if installed will perform version check to auto upgrade
* rsg  
    * Updated to have local version of revshells.com  
* nmap_vulners  
* gtfoblookup  
* navi  
* tomnomnom toys  
    * httprobe  
    * waybackurls  
    * unfurl  
    * fff  
    * hacks  
* nahamsec_stuff  
* neo4j  
* bloodhound  
* sublist3r  
* asnlookup  
* evil_winrm  
* powercat  
* more_wordlists  
* gobuster  
* recursivegobuster  
* enum4linux_ng  
* evilportals_wifipineapple  
* stegoVeritas  
* crackmapexec  
* extra repositories  
* dnstwist  
* autoenum  
* easysploit  
* sherlock  
* threader3000  
* locate  
* seclists  
* dnsdumpster  
* github_search  
* shodan_cli  
* interlace  
* certspotter  
* cloudbrute  
* gau  
    * if installed will perform version check to auto upgrade
* massdns  
* autorecon  
* hetty  
    * if installed will perform version check to auto upgrade
* gospider  
* phprevshell  
* instashell  
* wesng  
* metabigor  
* pspy  
* feroxbuster  
    * if installed will perform version check to auto upgrade
  
  
## v0.03
* Updated methods for finding binaries for github since github changed they way they are indexing them now.  
* Came up with using new indexing Github is using a way to do version checks on some of these items and check against what the latetest version the github repository has.  If they do not match, they will be downloaded, and instaled.  This is not being done with all items yet, but now I know how this can work and I will be rolling it out for the rest of the items when I have more time.  Some things are just able to be installed witht apt install and updatable with apt upgrade so if that is the case, ill just use that over the github method.  It works though, check out the fucntion "install_aquatone" to see.
* Overall cleanup of ways i was using bash and looking for ways to sharpen and refine the functions to make them more robust and functional.
* When i have more time, i'll be rolling out more toys/tools with this.
* Thanks for sticking around.
  
## v0.02
* Checks for installs and will move to the next if it sees file/folder exists already.  This way it will only add the items that you currently don't have or will skip and continue through.
    * --skip option added to bypass pimpmykali and continue with installing tools
  
  
## v0.01  
* initial script was set to run at new VM image.  Not intended to run multiple times.  Very rough draft.  
* installed tools but did not check if they existed already  
  
  
## Things to fix  
* Would like to eventually have a menu option to go through and skip anything that the users would want to go past.   
* I am sure more things will arise.  
  
  
