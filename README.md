# ssrfuzz
Fuzzer script for finding hidden parameters and SSRF for bug bounty.

## Requirements
- [httpx](https://github.com/projectdiscovery/httpx)
- [gau](https://github.com/lc/gau)
- [Burp Professional](https://portswigger.net/burp/pro)

## Usage
1. Run Burp proxy on http://127.0.0.1:8080
2. Run Burp Collaborator client
3. Run script with `./ssrfuzz.sh <domain> <burp collaborator link> <parameter list>`

Credits to [Santosh Kumar Sha](https://notifybugme.medium.com/about) for idea.
