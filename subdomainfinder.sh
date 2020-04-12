#!/bin/bash

url=$1



if [ ! -d "$url" ];then
	mkdir $url
fi

if [ ! -d "$url/recon" ];then
	mkdir $url/recon
fi



echo "[+] Harvesting Subdomains with assetfinder..."
assetfinder $url >> $url/recon/assets.txt
cat $url/recon/assets.txt | grep $1 >> $url/recon/subdomains.txt
rm $url/recon/assets.txt
echo "[+] Subdomains of $1 are harvested with assetfinder"

echo " "

echo "[+] Harvesting Subdomains with OWASP Amass..."
amass enum -d $url >> $url/recon/assets.txt
sort -u $url/recon/assets.txt >> $url/recon/subdomains.txt
rm $url/recon/assets.txt
echo "[+] Subdomains of $1 are harvested with OWASP Amass"

echo " "

echo "[+] Probing for alive domains and sorting the final result "

cat $url/recon/subdomains.txt | sort -u | httprobe -s -p https:443 | sed 's/https\?:\/\///' | tr -d ':443' >> $url/recon/alivedomains.txt


sleep 1

echo "[+] All the subdomains are at $url/recon/sundomains.txt"

echo " "

echo "[+] All the alive subdomains are at $url/recon/alivedomains.txt"

echo " "
echo "To look at Results: "

echo "cat $url/recon/subdomains.txt"
echo "cat $url/recon/alivesubdomains.txt"

echo " "

