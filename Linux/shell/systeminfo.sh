#!/bin/bash
#
#this is a shell to print the systeminfo
#
#
#
prinf_systeminfo(){
	echo "$(hostname)"
	echo "$(date)"
	echo "$(uname -r)"
}

#prinf_diskinfo(){
#
#}
main(){
	clear
	prinf_systeminfo
#	prinf_cpuinfo()
#	prinf_diskinfo()

	echo "end!"
}

main
