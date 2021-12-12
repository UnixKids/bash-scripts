# Source global definitions
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

## Source Nexcess functions (needed for nume and me)
if [ -f /etc/bashrc.nexcess ]; then
        . /etc/bashrc.nexcess
fi

export PATH=$PATH:/usr/local/sbin:/sbin:/usr/sbin:/var/qmail/bin:/usr/nexkit/bin:~/bin/
export GREP_OPTIONS='--color=auto'
export PAGER=/usr/bin/less

export EDITOR=/usr/bin/nano
export VISUAL=/usr/bin/nano

# protect myself from myself
alias rm='rm --preserve-root'
alias chown='chown --preserve-root'
alias chmod='chmod --preserve-root'
alias chgrp='chgrp --preserve-root'
alias ipp='curl https://ipinfo.io/$1'
alias httpdt='sudo httpd -t && sudo service httpd reload'
alias getuser="readlink -f . | sed 's:^/chroot::' | cut -d/ -f3"
# With -F, on listings append the following
#    '*' for executable regular files
#    '/' for directories
#    '@' for symbolic links
#    '|' for FIFOs
#    '=' for sockets
alias ls='ls -F --color=auto'

# only append to bash history to prevent it from overwriting it when you have
# multiple ssh windows open
shopt -s histappend
# save all lines of a multiple-line command in the same history entry
shopt -s cmdhist
# correct minor errors in the spelling of a directory component
shopt -s cdspell
# check the window size after each command and, if necessary, updates the values of LINES and COLUMNS
shopt -s checkwinsize


txtblk='\[\e[0;30m\]' # Black - Regular
txtred='\[\e[0;31m\]' # Red
txtgrn='\[\e[0;32m\]' # Green
txtylw='\[\e[0;33m\]' # Yellow
txtblu='\[\e[0;34m\]' # Blue
txtpur='\[\e[0;35m\]' # Purple
txtcyn='\[\e[0;36m\]' # Cyan
txtwht='\[\e[0;37m\]' # White
bldblk='\[\e[1;30m\]' # Black - Bold
bldred='\[\e[1;31m\]' # Red
bldgrn='\[\e[1;32m\]' # Green
bldylw='\[\e[1;33m\]' # Yellow
bldblu='\[\e[1;34m\]' # Blue
bldpur='\[\e[1;35m\]' # Purple
bldcyn='\[\e[1;36m\]' # Cyan
bldwht='\[\e[1;37m\]' # White
unkblk='\[\e[4;30m\]' # Black - Underline
undred='\[\e[4;31m\]' # Red
undgrn='\[\e[4;32m\]' # Green
undylw='\[\e[4;33m\]' # Yellow
undblu='\[\e[4;34m\]' # Blue
undpur='\[\e[4;35m\]' # Purple
undcyn='\[\e[4;36m\]' # Cyan
undwht='\[\e[4;37m\]' # White
txtrst='\[\e[0m\]'    # Text Reset
hostname_region=${HOSTNAME%.nxcli.net}
hostname_region=${hostname_region%.nexcess.net}

if [ $UID = 0 ]; then
    # nexkit bash completion
    if [ -e '/etc/bash_completion.d/nexkit' ]; then
  source /etc/bash_completion.d/nexkit
    fi
    PS1="[${txtcyn}\$(date +%H%M)${txtrst}][${bldred}\u${txtrst}@${hostname_region} \W]\$ "
else
    PS1="[${txtcyn}\$(date +%H%M)${txtrst}][\u@${hostname_region} \W]\$ "
    fi
function sup_cdapa(){
#/bin/bash
USER=$(readlink -f . | sed 's:^/chroot::' | cut -d/ -f3 )
DOMAIN=$(readlink -f . | sed 's:^/chroot::' | cut -d/ -f4)

if [[ -z $1 ]]
        then
                echo "/home/${USER}/var/${DOMAIN}/apache"
                cd /home/${USER}/var/${DOMAIN}/apache 2> /dev/null
                if [[ $? -gt 0 ]]
                        then
                                printf "Change directories using sup_cdd [domain]\n -u [user] and -d [domain]\n"
                fi
fi
while [[ -n $1 ]]
        do
                case $1 in
                "-u"|"--user")
                                USER=$2
                                shift
                                ;;
                "-d"|"domain")
                                DOMAIN=$2
                                shift
                                ;;
                #"-h|--help")
                                #echo "This command changes to the Apache configuration directory for a specific domain\n"
                                #exit
                                #;;
                        esac
                shift
        done
printf "${DOMAIN}\n"
echo "/home/${USER}/var/${DOMAIN}/apache"
cd /home/${USER}/var/${DOMAIN}/apache
if [[ $? -gt 0 ]]
                        then
                                printf "Either the user or domain no does not exist. Specify either by using -u [user] or -d [domain]\n"
                fi
}

chkbase(){
#!/bin/bash
source ~/.bashrc


DIR=$(readlink -f . | sed 's:^/chroot::' | cut -d/ -f-4)
MAGENTO2_DB=$(sudo cat  ${DIR}/app/etc/env.php 2> /dev/null | awk '/dbname/{print $3}' | sed s'/,//'g | sed "s/'//"g)
MAGENTO2_DB2=$(sudo cat  ${DIR}/html/app/etc/env.php 2> /dev/null | awk '/dbname/{print $3}' | sed s'/,//'g | sed "s/'//"g)
MAGENTO1_DB=$(sudo cat ${DIR}/html/app/etc/local.xml 2> /dev/null | grep -i db | grep -Po $(readlink -f . | sed 's:^/chroot::' | cut -d/ -f3)'_\w+')
MAGENTO1_TABLE=($(m $MAGENTO1_DB -e'SHOW TABLES  LIKE "%core_config_data%"' 2> /dev/null | grep -v '%' |grep -Po '(\w+)?core\w+'))
MAGENTO2_TABLE=($(m $MAGENTO2_DB -e'SHOW TABLES  LIKE "%core_config_data%"' 2> /dev/null | grep -v '%' |grep -Po '(\w+)?core\w+'))
MAGENTO2_TABLE2=($(m $MAGENTO2_DB2 -e'SHOW TABLES  LIKE "%core_config_data%"' 2> /dev/null | grep -v '%' |grep -Po '(\w+)?core\w+'))

WORDPRESS_DB=$(sudo cat ${DIR}/html/wp-config.php 2> /dev/null |awk '/DB_NAME/{print $3}' | sed "s/'//g")
WORDPRESS_TABLE=($(m $WORDPRESS_DB -e'SHOW TABLES LIKE "%wp_options%"' 2> /dev/null | grep -v '%' | grep -Po '(\w+)?wp\w+'))

if [[ -e ${DIR}'/app/etc/env.php' ]]
then
        for TABLE in ${MAGENTO2_TABLE[*]};
        do
        m $MAGENTO2_DB -e"SELECT * FROM $TABLE WHERE path LIKE '%web%secure%'"
        done

elif [[ -e ${DIR}'/html/app/etc/env.php' ]];
then
        for TABLE in ${MAGENTO2_TABLE2[*]};
        do
        m $MAGENTO2_DB2 -e"SELECT * FROM $TABLE WHERE path LIKE '%web%secure%'"
        done

elif [[ -e ${DIR}'/html/app/etc/local.xml' ]];
then
        for TABLE in ${MAGENTO1_TABLE[*]};
        do
        m $MAGENTO1_DB -e"SELECT * FROM $TABLE WHERE path LIKE '%web%secure%'"
        done

elif [[ -e ${DIR}'/html/wp-config.php' ]];
then
        for TABLE in ${WORDPRESS_TABLE[*]};
        do
        m $WORDPRESS_DB -e"SELECT * FROM $TABLE WHERE option_name = 'siteurl' OR  option_name = 'home'"
        done
else
	echo 'Please go to the document root.'
fi
}

dkim ()
{
~iworx/bin/domainkeys.pex --domain $1;
wait;
sudo cat /etc/domainkeys/$1/rsa.public
}
makecsr() {
# Makes an SSL private key and CSR - Usage: makecsr example.com
    if [ "$1" ]; then
        success=0
        echo -e '====================\n   Creating CSR...\nUSE FULL STATE NAME!\n===================='
        openssl genrsa -out ${1}.key 2048 && openssl req -new -key ${1}.key -out ${1}.csr && success=1
        if [ "$success" == 1 ]; then
            echo -e '====================\ncreated:\n'
            echo ${1}.key
            echo ${1}.csr
        else echo 'Failure!'
        fi
    else echo 'Domain required!'
    fi
}
