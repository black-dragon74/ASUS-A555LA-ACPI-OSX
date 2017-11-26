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

inputValue="$1"
downloadFolder=$(getFolderPath $inputValue)
targetOS="10.13" # Only use first two numbers. Like, If you are running 10.12.6 you would set targetOS="10.12" not "10.12.6"
kFolder=$downloadFolder/kInstall
tFolder=$downloadFolder/tInstall

function extractKexts(){
	echo -e "Kexts folder found. Extracting kexts.\n"
	cd kexts
	for f in $(ls | grep "zip"); do
		echo "Expanding $f" && sleep 0.5
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
		echo "Expanding $f" && sleep 0.5
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