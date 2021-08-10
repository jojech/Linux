#! /bin/bash
#
# Author: Jeremy Johnson
#

login=$1
password=$2
shell=$3

function print_usage () {
	echo "Usage:" 
	echo "myuseradd.sh -a <login> <passwd> <shell> 	Add a user account"
	echo "myuseradd.sh -d <login> 					Remove a user account"
	echo "myuseradd.sh -h 							Display this usage message"
}

function delete_user () {
	touch file1
	getent passwd $login >file1
	if (("$?" != 0))
	then
	echo "ERROR: $login does not exist"
	else
	userdel -r "$login"
	echo "$login is deleted"
	fi
}

function add_user () {
	touch file1
	getent passwd $login &>file1
	if (("$?" != 0))
	then
	useradd -m "$login" &>>file1
	echo "$password" | passwd --stdin "$login" &>>file1
	chsh -s "$shell" "$login" &>>file1
	echo "$login ($password) with $shell is added"
	else
	echo "ERROR: $login exists"
	fi
}

function parse_command_options () {


	case "$1" in
	-h )
		print_usage
		;;
	-d )
		delete_user
		;;
	-a )
		add_user
		;;	
	* )
		echo "Error: invalid option: $1"
		print_usage
		;;
	esac
}

parse_command_options "$@" 

