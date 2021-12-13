# shellcheck shell=bash

# @file print.sh
# @brief Prints statements that are not indented

bprint.die() {
	bprint.error "$1"
	exit 1
}

# Fatal errors are internal errors here
bprint.fatal() {
	if [ -n "${NO_COLOR+x}" ] || [ "$TERM" = dumb ]; then
		printf "%11s: %s\n" "Fatal" "$1" >&2
	else
		printf "\033[0;31m%11s\033[0m %s\n" 'Fatal' "$1" >&2
	fi

	# Print stack trace
	if (( ${#FUNCNAME[@]} >> 2 )); then
		printf '%s\n' 'STACK TRACE'
        for ((i=1;i<${#FUNCNAME[@]}-1;i++)); do
			printf '%s\n' "  $i: ${BASH_SOURCE[$i+1]}:${BASH_LINENO[$i]} ${FUNCNAME[$i]}(...)"
        done
    fi

	exit 1
}

bprint.error() {
	if [ -n "${NO_COLOR+x}" ] || [ "$TERM" = dumb ]; then
		printf "%11s: %s\n" "Error" "$1" >&2
	else
		printf "\033[0;31m%11s\033[0m %s\n" 'Error' "$1" >&2
	fi
}

bprint.warn() {
	if [ -n "${NO_COLOR+x}" ] || [ "$TERM" = dumb ]; then
		printf "%11s: %s\n" 'Warning' "$1" >&2
	else
		printf "\033[0;33m%11s\033[0m %s\n" 'Warning' "$1" >&2
	fi
}

bprint.info() {
	if [ -n "${NO_COLOR+x}" ] || [ "$TERM" = dumb ]; then
		printf "%11s: %s\n" 'Info' "$1"
	else
		printf "\033[0;32m%11s\033[0m %s\n" 'Info' "$1" 
	fi
}

bprint.green() {
	if [ -n "${NO_COLOR+x}" ] || [ "$TERM" = dumb ]; then
		printf "%11s: %s\n" "$1" "$2"
	else
		printf "\033[0;32m%11s\033[0m %s\n" "$1" "$2"
	fi
}