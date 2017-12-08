#!/bin/bash

# Code is poetry

# Written by RehabMan, black.dragon74

tfile="/tmp/nick_download.txt"

function downloadFromBit()
{
    echo "downloading $2:"
    curl --location --silent --output $tfile https://bitbucket.org/RehabMan/$1/downloads/

    # Use sed for faster processing
    scrape=$(grep -o -m 1 "/RehabMan/$1/downloads/$2.*\.zip" $tfile | sed 's/^.*>//')
    url=https://bitbucket.org/RehabMan/$1/downloads/$scrape

    echo $url

    curl --remote-name --progress-bar --location "$url"
    
    echo " "
}

function downloadFromGit(){

	# $1 = Name of author
	# $2 = Name of kext

	if [[ -z $1 || -z $2 ]]; then
		echo "Inavlid args. Aborted"
	fi

	# Tell user
	echo "Downloading: $2"

	# Send a curl to get url source
	curl --location --silent --output $tfile https://github.com/$1/$2/releases/

	# Clean URL to get download link
	scrape="$(cat $tfile | grep "RELEASE" | grep -m1 "$1/$2/releases/download/" | awk '{print $2}' | sed 's/^.*"\///g' | sed 's/"//g')"

	# Append github to form a full URL
	url=https://github.com/$scrape

	echo $url

	curl -o $2.zip --remote-name --progress-bar --location "$url"

	echo
}

echo -e "Script for ASUS laptops by black.dragon74\n"

cd $(dirname $0)

if [ ! -d ./downloads ]; then mkdir ./downloads; fi && rm -Rf downloads/* && cd ./downloads

# Download kexts, uncomment the ones you want to download
mkdir ./kexts && cd ./kexts
downloadFromBit os-x-fakesmc-kozlek RehabMan-FakeSMC
#downloadFromBit os-x-voodoo-ps2-controller RehabMan-Voodoo
downloadFromBit os-x-realtek-network RehabMan-Realtek-Network
downloadFromBit os-x-acpi-battery-driver RehabMan-Battery
downloadFromBit os-x-eapd-codec-commander RehabMan-CodecCommander
downloadFromBit os-x-fake-pci-id RehabMan-FakePCIID
downloadFromBit os-x-usb-inject-all RehabMan-USBInjectAll
downloadFromBit intelgraphicsfixup RehabMan-IntelGraphicsFixup
#downloadFromBit os-x-acpi-debug RehabMan-Debug
downloadFromBit os-x-acpi-poller RehabMan-Poller

# Downloads from GitHub
downloadFromGit vit9696 Lilu
downloadFromGit vit9696 AppleALC
downloadFromGit black-dragon74 ATH9KFixup

# Simple Downloads
echo "Downloading: Kexts.zip"
echo "https://raw.githubusercontent.com/black-dragon74/ASUS-A555LA-ACPI-OSX/master/Kexts.zip"
curl -o Kexts.zip --progress-bar "https://raw.githubusercontent.com/black-dragon74/ASUS-A555LA-ACPI-OSX/master/Kexts.zip"
echo

# Change dir
cd ..

# download tools
mkdir ./tools && cd ./tools
downloadFromBit os-x-maciasl-patchmatic RehabMan-patchmatic
downloadFromBit os-x-maciasl-patchmatic RehabMan-MaciASL
downloadFromBit acpica iasl iasl.zip
cd ..

# Download clover related files
mkdir ./clover && cd ./clover
echo "Downloading: HFSPlus.efi"
echo "https://raw.githubusercontent.com/black-dragon74/ASUS-A555LA-ACPI-OSX/master/HFSPlus.efi"
curl -o HFSPlus.efi --progress-bar "https://raw.githubusercontent.com/black-dragon74/ASUS-A555LA-ACPI-OSX/master/HFSPlus.efi"
echo

echo "Downloading: config.plist"
echo "https://raw.githubusercontent.com/black-dragon74/ASUS-A555LA-ACPI-OSX/master/config.plist"
curl -o config.plist --progress-bar "https://raw.githubusercontent.com/black-dragon74/ASUS-A555LA-ACPI-OSX/master/config.plist"
echo

cd ..
#EOF
