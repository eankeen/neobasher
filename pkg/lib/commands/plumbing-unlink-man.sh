# shellcheck shell=bash

basher-plumbing-unlink-man() {
	local package="$1"

	local files=("$NEOBASHER_PACKAGES_PATH/$package"/man/*)
	files=("${files[@]##*/}")

	local regex="\.([1-9])\$"
	for file in "${files[@]}"; do
		if [[ "$file" =~ $regex ]]; then
			local n="${BASH_REMATCH[1]}"

			rm -f "$NEOBASHER_INSTALL_MAN/man$n/$file"
		fi
	done
}