# shellcheck shell=sh

include() {
	package="$1"
	file="$2"

	if [ -z "$BPM_PREFIX" ]; then
		printf "%s\n" "Error: 'BPM_PREFIX' is empty" >&2
		return 1
	fi

	if [ -z "$package" ] || [ -z "$file" ]; then
		printf "%s\n" "Error: Usage: include <package> <file>" >&2
		return 1
	fi

	if [ ! -d "$BPM_PREFIX/packages/$package" ]; then
		printf "%s\n" "Error: Package '$package' not installed" >&2
		return 1
	fi

	if [ ! -f "$BPM_PREFIX/packages/$package/$file" ]; then
		printf "%s\n" "Error: File '$BPM_PREFIX/packages/$package/$file' not found" >&2
		return 1
	fi

	. "$BPM_PREFIX/packages/$package/$file" >&2

	unset package file
}
