#/bin/bash

# Code is poetry

# Script to install downloaded files by black.dragon74

function getFolderPath(){
	if [[ -d $1 ]]; then
		cd $1
		echo $(pwd)
	else
		echo "$1" # So that the program exits
	fi
}

cpath=""
inputValue="$1"
downloadFolder=$(getFolderPath $inputValue)
cFolder=kFolder=$downloadFolder/clover
kFolder=$downloadFolder/kInstall
tFolder=$downloadFolder/tInstall
appFolder="/Applications"
binFolder="/usr/bin"
daeFolder="/Library/LaunchDaemons"

function extractKexts(){
	echo -e "Kexts folder found. Extracting kexts.\n"
	cd kexts
	if [[ -e CLOVER.zip ]]; then
		mv CLOVER.zip ../
		echo "Moved CLOVER directory."
	fi
	for f in $(ls | grep "zip"); do
		echo "Expanding $f" && sleep 0.2
		unzip -o -qu $f
	done

	# Remove debug directory if it exists
	if [[ -d Debug ]];
		then
		echo -e "\nRemoved Debug versions"
		rm -rf Debug
	fi

	# Move all kexts to a new folder in download folder's root
	if [[ -e $kFolder ]];
		then
		rm -rf $kFolder
		mkdir -p $kFolder
	else
		mkdir -p $kFolder
	fi

	cd Release
	echo "Moving all kexts to $kFolder"
	for f in $(ls | grep "kext");
	do
		mv $f $kFolder
	done

	# If anything remains, that should me moved to tools installation folder
	if [[ -e $tFolder ]];
		then
		rm -rf $tFolder
		mkdir -p $tFolder
	else
		mkdir -p $tFolder
	fi

	echo -e "\nMoving binaries found in releases to $tFolder"
	for f in $(ls | grep -v "kext" );
	do
		echo "Moved $f"
		mv $f $tFolder
	done

	# Come back and delete release folder
	cd .. && rm -rf Release

	# Delete bogus stuffs
	rm .DS_Store &>/dev/null
	rm -rf __MACOSX &>/dev/null
	rm -rf *.dSYM

	# Check2 for kexts and other stuffs in main dir
	for f in $(ls | grep "kext");
	do
		mv $f $kFolder
	done

	# If anything else except zip files is left, that should go to tools folder
	echo -e "\nMoving stuffs found in root to $tFolder"
	for f in $(ls | grep -v "zip");
	do
		echo "Moved $f"
		mv $f $tFolder
	done
}

function extractTools(){
	# Done with kexts. Now proceed to tools
	echo -e "\nDone with kexts. Proceeding to tools extraction.\n" && sleep 1
	cd $downloadFolder/tools
	for f in $(ls | grep "zip"); do
		echo "Expanding $f" && sleep 0.2
		unzip -o -qu $f
	done

	echo -e "\nMoving all tools to $tFolder"
	for f in $(ls | grep -v "zip");
	do
		echo "Moved $f"
		mv $f $tFolder
	done

	# Done with tools
	echo -e "\nTools extraction completed.\n" && sleep 1
}

function installKexts(){
	cd $kFolder
	
	# Deal with normal kexts
	normallist=$(ls | grep -vE "FakeSMC_|FakePCIID_|Lilu|IntelGraphicsFix|AppleALC|ATH9KFixup")
	for f in $normallist;
	do
		sudo cp -rf $f $kextdir
		echo Installed $f to $kextdir
		if [[ $f != "FakeSMC.kext" ]]; then
			if [[ $f != "ApplePS2SmartTouchPad.kext" ]]; then
				rm -rf $f
			fi
		fi
	done

	# Deal with FakeSMC kext's plugins
	fakesmclist=$(ls | grep "FakeSMC_")
	for f in $fakesmclist;
	do
		# Ask if he wants to install that kext
		read -p "Do you want to install $f: " fakeans
		case $fakeans in
			[yY]* )
				sudo cp -rf $f $kextdir
				;;
			* )
				:
				;;	
		esac
		rm -rf $f
	done

	# Deal with FakePCIID's plugins
	fakepcilist=$(ls | grep "FakePCIID_")
	for f in $fakepcilist;
	do
		read -p "Do you want to install $f: " fakepcians
		case $fakepcians in
			[yY]* )
				sudo cp -rf $f $kextdir
				;;
			* )
				:
				;;
		esac
		rm -rf $f
	done

	# Remaning kexts are to be injected by bootloader
	# TODO: Automate bootloader injection
	echo
	read -p "Please mount EFI partition and press ENTER "
	if [ -e /Volumes/EFI/EFI/CLOVER ];
		then
		cpath=/Volumes/EFI/EFI/CLOVER
	elif [ -e /Volumes/ESP/EFI/CLOVER ];
		then
		cpath=/Volumes/EFI/EFI/CLOVER
	elif [ -e /Volumes/EFI\ 1/EFI/CLOVER ];
		then
		cpath=/Volumes/EFI/EFI/CLOVER
	elif [ -e /Volumes/EFI\ 01/EFI/CLOVER ];
		then
		cpath=/Volumes/EFI/EFI/CLOVER
	else
		echo "EFI partition not mounted. Aborted."
		exit
	fi
	echo "EFI Volume mounted at $cpath"
	echo

	# Copy kexts to CLOVER/Other
	echo -e "Installing kexts to be injected by CLOVER\n"
	if [[ -e $cpath/kexts/Other ]]; then
		echo "Injection directory found."
	else
		echo "Injection directory not found. Creating."
		mkdir $cpath/kexts/Other
	fi

	echo

	injectlist=$(ls | grep "kext")
	for f in $injectlist; do
		cp -rf $f $cpath/kexts/Other
		echo Injected $f && sleep 0.2
		rm -rf $f
	done

	echo

	# Finished
	echo -e "All kexts have been installed.\n"
}

function installTools(){
	# There are three types of tools: Apps, Binaries and LaunchDaemons
	cd $tFolder

	# Take care of Applications
	applist=$(ls | grep "app")
	if [[ $applist != "" ]]; then
		for f in $applist; do
			echo "Copied $f to $appFolder"
			sudo cp -rf $f $appFolder
			rm -rf $f
		done
	fi

	# Take care of the binaries
	binlist=$(ls | grep -vE "app|plist")
	if [[ $binlist != "" ]]; then
		for f in $binlist; do
			echo "Installed $f to $binFolder"
			sudo cp -rf $f $binFolder
			rm -rf $f
		done
	fi

	# Take care of the LaunchDaemons
	daelist=$(ls | grep "plist")
	if [[ $daelist != "" ]]; then
		for f in $daelist; do
			echo Installed $f to $daeFolder
			sudo cp -rf $f $daeFolder
			rm -rf $f
		done
	fi

	# Finished
	echo -e "\nAll tools have been installed.\n"
}

function rebuildCacPer(){
	sudo chmod -Rf 755 /L*/E*
	sudo chown -Rf root:wheel /L*/E*
	sudo chmod -Rf 755 /S*/L*/E*
	sudo chown -Rf root:wheel /S*/L*/E*
	sudo kextcache -i / &>/dev/null
	echo -e "Done. Reboot and enjoy!"
	exit
}

function setupClover(){
	cd $cFolder
	cp config.plist $cpath
	cp HFSPlus.efi $cpath/drivers64UEFI
	rm *
}

# Clear
clear

# Signature
echo -e "Script for ASUS laptops by black.dragon74\n"

if [[ -d $downloadFolder ]];
	then
	echo -e "Folder identified as: $downloadFolder\n"
	cd $downloadFolder

	if [[ -d kexts ]];
		then
		extractKexts

		if [[ -d $downloadFolder/tools ]];
			then
			extractTools
		fi
	else
		read -p "Kexts directory not found. Look for tools?: " prompt1
		case $prompt1 in
			[yY]* )
				if [[ -d tools ]]; then
					if [[ -e $tFolder ]]; then
						rm -rf $tFolder
						mkdir -p $tFolder
					else
						mkdir -p $tFolder
					fi
					extractTools
				else
					echo "Tools folder not found. Exiting."
					exit 0
				fi
				;;
			[nN]* )
				echo "Okay. Aborting."
				exit 0
				;;
			* )
				echo "Invalid input. Aborting."
				exit 0
				;;		
		esac
	fi
else
	echo "$downloadFolder is an invalid input."
	exit 0
fi

# Now proceed for installation
# Install kexts
kextdir=""
swver=$(sw_vers -productVersion | sed 's/\.//g' | colrm 5)

# Determine location to install to
if [[ $swver -ge "1011" ]]; then
	kextdir="/Library/Extensions"
else
	kextdir="/System/Library/Extensions"
fi

# If 10.11 or less IntelGraphicsFixup is not needed.
if [[ $swver -le "1011" ]]; then
	cd $kFolder

	#For IntelGraphicsFixup
	if [[ -e IntelGraphicsFixup.kext ]]; then
		rm -rf IntelGraphicsFixup.kext
	fi
fi

echo -e "Proceeding to install kexts...\n"

echo "Requesting superuser access..."
if [[ $(sudo id -u 2>/dev/null) != "0" ]]; then
	echo "Authentication failed. Aborting."
	exit
fi
echo

# Install kexts
installKexts

# Install tools
echo -e "Proceeding to install tools...\n"
installTools

# Setup Clover
echo -e "Setting up CLOVER..."
setupClover
echo -e "Clover is setup and ready to go!...\n"

# Rebuild caches and fix permissions
echo -e "Fixing permissions and rebuilding caches...\n"
rebuildCacPer

#EOF
