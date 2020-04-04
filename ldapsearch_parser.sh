#!/bin/bash

# This script has no logic, things may not work. why? because it is a simple script to parse ldapsearch queries.
# ldapsearch is REQUIRED.
# EXAMPLE ./ldapsearch_parser.sh <IP-ADDRESS>

echo ""
echo "========================================================================================="
echo -e "\e[32m\e[1m[+] Welcome to LDAP Hunter - May the luck be with you, this is a dumb script \e[39m\e[0m"
echo "========================================================================================="
echo -e "\e[91m\e[1m[-] Author: S4gi (iRawrTwice)"
echo "[-] Version: 1.0 "
echo "[-] Updated last at April 4th 2020 "
echo -e "[-] Honestly its just a parser \e[39m\e[0m"
echo ""

echo "========================================================================================="
echo -e "\e[32m\e[1m[+] Grabbing domain base namingContext \e[39m\e[0m"
echo "========================================================================================="
echo ""

NC=$(ldapsearch -LLL -x -h $1 -s base | grep "namingContexts: DC=" | grep -v "namingContexts: DC=Domain\|namingContexts: DC=Forest" | awk '{print $2}')
echo "[+] Got '$NC'"

#this might error when it catches more then one namingContext, to fix it, add the "namingContexts: DC=<WHATEVER>" to the grep -v

echo ""
echo "========================================================================================="
echo -e "\e[32m\e[1m[+] Trying to find Passwords \e[39m\e[0m"
echo "========================================================================================="
echo ""

ldapsearch -LLL -x -h $1 -b ''$NC'' | grep "Pwd\|Legacy\|password\|Password\|pwd\|legacy\|Backup\|backup" | grep -v "Age\|Length\|Count\|Time\|Settings\|Denied\|Allow\|Members\|LastSet\|Propertie\|Name\|name\|cn\|OU\|CN\|description\|Expire" | sort -u

echo ""
echo "========================================================================================="
echo -e "\e[32m\e[1m[+] Collecting Users objects | aka as 'userPrincipalName' \e[39m\e[0m"
echo "========================================================================================="
echo ""

ldapsearch -LLL -x -h $1 -b ''$NC'' | grep "userPrincipalName" | awk '{print $2}' | sort -u 

echo ""
echo "========================================================================================="
echo -e "\e[32m\e[1m[+] Collecting Services objects | aka as 'servicePrincipalName' \e[39m\e[0m"
echo "========================================================================================="
echo ""

ldapsearch -LLL -x -h $1 -b ''$NC'' | grep "servicePrincipalName" | awk '{print $2}' | sort -u

echo ""
echo "========================================================================================="
echo -e "\e[32m\e[1m[+] Parsing Potential Usernames \e[39m\e[0m"
echo "========================================================================================="
echo ""

ldapsearch -LLL -x -h $1 -b ''$NC'' | grep "userPrincipalName" | awk '{print $2}' | cut -d'@' --complement -s -f2 | sort -u 

echo ""
echo "========================================================================================="
echo -e "\e[32m\e[1m[+] THE END \e[39m\e[0m"
echo "========================================================================================="
echo ""

