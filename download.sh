#!/bin/bash

# Code is poetry

# Written by RehabMan, custom tuned by black.dragon74

function download()
{
    echo "downloading $2:"
    curl --location --silent --output /tmp/download.txt https://bitbucket.org/RehabMan/$1/downloads/

    # Use sed for faster processing
    scrape=$(grep -o -m 1 "/RehabMan/$1/downloads/$2.*\.zip" /tmp/download.txt| sed 's/^.*>//')
    url=https://bitbucket.org/RehabMan/$1/downloads/$scrape

    echo $url

    curl --remote-name --progress-bar --location "$url"
    
    echo " "
}

cd $(dirname $0)

if [ ! -d ./downloads ]; then mkdir ./downloads; fi && rm -Rf downloads/* && cd ./downloads

# Download kexts, uncomment the ones you want to download
mkdir ./kexts && cd ./kexts
download os-x-fakesmc-kozlek RehabMan-FakeSMC
#download os-x-voodoo-ps2-controller RehabMan-Voodoo
download os-x-realtek-network RehabMan-Realtek-Network
download os-x-acpi-battery-driver RehabMan-Battery
download os-x-eapd-codec-commander RehabMan-CodecCommander
download os-x-fake-pci-id RehabMan-FakePCIID
download os-x-usb-inject-all RehabMan-USBInjectAll
download lilu RehabMan-Lilu
download intelgraphicsfixup RehabMan-IntelGraphicsFixup
#download os-x-acpi-debug RehabMan-Debug
cd ..

# download tools
mkdir ./tools && cd ./tools
download os-x-maciasl-patchmatic RehabMan-patchmatic
download os-x-maciasl-patchmatic RehabMan-MaciASL
download acpica iasl iasl.zip
cd ..
