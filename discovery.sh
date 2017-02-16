#!/bin/bash
#Bash Security
#
#Usage:
#./discovery.sh http://www.clarin.com/ fuzzing.txt 20 >out.log
#

DOMAIN_NAME="$1"
FILE_INPUT="$2"
NUMBER_OF_PROCESS="$3"
DEFAULT_PROCESS="10"

function task(){
	fileNum="$1"
	for i in $(cat $fileNum); do
		out=$(curl -s "$DOMAIN_NAME/$i" | wc -l)
		echo "$(date) $out $i"
	done
}

function loader(){
	for i in $(ls *.part); do 
		task $i &
		sleep 1
	done
}

function cleaner(){
	rm *.part
}

function init(){

	rm *.part

	if [ "$NUMBER_OF_PROCESS" == "" ]; then
		let NUMBER_OF_PROCESS=DEFAULT_PROCESS;
	fi

	let p=NUMBER_OF_PROCESS-1
	split -da $p -l $(($(wc -l < $FILE_INPUT)/$p)) $FILE_INPUT part --additional-suffix=".part"
}


function main(){	
	init
	loader
	cleaner
}

main
