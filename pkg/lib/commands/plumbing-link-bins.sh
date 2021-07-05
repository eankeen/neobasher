# shellcheck shell=bash

basher-plumbing-link-bins() {
	local package="$1"

	ensure.nonZero 'package' "$package"

	local -a bins=()
	if [ -f "$NEOBASHER_PACKAGES_PATH/$package/package.sh" ]; then
		source "$NEOBASHER_PACKAGES_PATH/$package/package.sh"
		IFS=: read -ra bins <<< "$BINS"
	fi

	if ((${#bins} == 0)); then
		if [ -e "$NEOBASHER_PACKAGES_PATH/$package/bin" ]; then
			bins=("$NEOBASHER_PACKAGES_PATH/$package"/bin/*)
			bins=("${bins[@]##*/}")
			bins=("${bins[@]/#/bin/}")
		else
			readarray -t bins < <(find "$NEOBASHER_PACKAGES_PATH/$package" -maxdepth 1 -mindepth 1 -perm -u+x -type f -or -type l)
			bins=("${bins[@]##*/}")
		fi
	fi

	for bin in "${bins[@]}"; do
		local name="${bin##*/}"

		if ${REMOVE_EXTENSION:-false}; then
			name="${name%%.*}"
		fi

		mkdir -p "$NEOBASHER_INSTALL_BIN"
		ln -sf "$NEOBASHER_PACKAGES_PATH/$package/$bin" "$NEOBASHER_INSTALL_BIN/$name"
		chmod +x "$NEOBASHER_INSTALL_BIN/$name"
	done

}