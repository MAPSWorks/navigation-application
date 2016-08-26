#!/bin/bash

navigation_version='1cfa51e76ba173166c113eccf6a61a5904ff7e7d'
positioning_version='f341b4a2cb216d6204136794d33076170ab1bf80'
navit_version='0a8f85666a3b849d70ed450d74bed3cf85466630'

echo "version of navigation is: $navigation_version"
echo "version of positioning is: $positioning_version"
echo "version of navit is: $navit_version"

echo -n "This script deletes, reloads and builds everything, are you sure ? (y or n) "
read input

if [ "$input" = 'n' ]
then
	exit 1
fi

if [ -d "./build" ]
then
	find ./build ! -name '*.cbp' -type f -exec rm -f {} +
fi
rm -rf navigation
rm -rf automotive-message-broker

git clone https://github.com/GENIVI/navigation.git ./navigation
cd navigation
git checkout $navigation_version
cd src/navigation
git clone https://github.com/GENIVI/positioning.git ./positioning
cd positioning
git checkout $positioning_version
cd ..
git clone https://github.com/navit-gps/navit.git
cd navit
git checkout $navit_version
patch -p0 -i ../patches/search_list_get_unique.diff
patch -p0 -i ../patches/fsa_issue_padding.diff
cd ../../../../

./build.sh -c



