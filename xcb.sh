#!/bin/bash

VERSION="1.0.0"

verbose=false

show_help() {
	echo "Usage: $(basename "$0") [options] [content]"
	echo "A simple utility to copy content to the clipboard. It basically wraps xsel, xclip, wl-clipboard, termux-api, and qdbus, using the first available."
	echo ""
	echo "Options:"
	echo -e "  -v, --version\t\tShows the version of the script."
	echo -e "  -d, --debug\t\tEnables debug mode (verbose)."
	echo -e "  -h, --help\t\tShows this help message."
	echo ""
	echo "Supported clipboard utilities: xsel, xclip, wl-clipboard, termux-api, and qdbus."
}

print_message() {
	if [ "$verbose" = true ]; then
		printf >&2 "$1"
	fi
}

command_exists() {
	command -v "$1" &>/dev/null
}

set_clipboard() {
	local content="$1"
	local message="Content copied to clipboard using %s"

	if command_exists xsel; then
		printf "$1" | xsel -i
		print_message "$(printf "$message" "xsel")"
	elif command_exists xclip; then
		printf "$1" | xclip -selection clipboard
		print_message "$(printf "$message" "xclip")"
	elif command_exists pbcopy; then
		printf "$1" | pbcopy
		print_message "$(printf "$message" "pbcopy")"
	elif command_exists wl-copy; then
		printf "$1" | wl-copy
		print_message "$(printf "$message" "wl-copy")"
	elif command_exists qdbus; then
		qdbus org.kde.klipper /klipper org.kde.klipper.klipper.setClipboardContents "$1"
		print_message "Content copied to KDE clipboard: $1"
	elif command_exists termux-clipboard-set; then
		printf "$1" | termux-clipboard-set
		print_message "$(printf "$message" "termux-clipboard-set")"
	else
		printf "No clipboard utility found. Please install xsel, xclip, wl-clipboard, or termux-api." >&2
		return 1
	fi
}

while :; do
	case $1 in
	-h | -\? | --help)
		show_help
		exit
		;;
	-v | --version)
		echo "xcb v$VERSION"
		exit
		;;
	-d | --debug)
		verbose=true
		;;
	-?*)
		printf "Unknown option: $1\n" >&2
		show_help
		exit
		;;
	*)
		break
		;;
	esac
	shift
done

if [ -n "$*" ]; then
	set_clipboard "$*"
elif [ -p /dev/stdin ]; then
	content=$(cat)
	set_clipboard "$content"
else
	printf "\033[36mReading from stdin...\033[0m "
	printf "\033[1;32mCtrl+D\033[0m to finish, \033[1;31mCtrl+C\033[0m to cancel\n"
	set_clipboard "$(cat)"
fi
