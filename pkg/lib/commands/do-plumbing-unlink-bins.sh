# shellcheck shell=bash

do-plumbing-unlink-bins() {
	local package="$1"
	ensure.nonZero 'package' "$package"

	local -a bins=()
	local REMOVE_EXTENSION=

	local packageShFile="$BPM_PACKAGES_PATH/$package/package.sh"
	if [ -f "$packageShFile" ]; then
		util.extract_shell_variable "$packageShFile" 'BINS'
		IFS=':' read -ra bins <<< "$REPLY"

		util.extract_shell_variable "$packageShFile" 'REMOVE_EXTENSION'
		REMOVE_EXTENSION="$REPLY"
	fi

	if ((${#bins} == 0)); then
		if [ -d "$BPM_PACKAGES_PATH/$package/bin" ]; then
			bins=("$BPM_PACKAGES_PATH/$package"/bin/*)
			bins=("${bins[@]##*/}")
			bins=("${bins[@]/#/bin/}")
		else
			readarray -t bins < <(find "$BPM_PACKAGES_PATH/$package" -maxdepth 1 -perm -u+x -type f -or -type l)
			bins=("${bins[@]##*/}")
		fi
	fi

	for bin in "${bins[@]}"; do
		local name="${bin##*/}"

		if "${REMOVE_EXTENSION:-false}"; then
			name="${name%%.*}"
		fi

		rm -f "$BPM_INSTALL_BIN/$name"
	done
}