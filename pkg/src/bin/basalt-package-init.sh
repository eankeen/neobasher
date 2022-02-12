# shellcheck shell=bash

# This command is similar to 'basalt global init bash', except that it is only used by
# Bash applications (and test initialization procedures of Bash libraries) to load in
# all the Basalt functions in the current shell context. It must be a binary rather
# than a function because any new Bash contexts won't inherit functions of previous
# contexts, but will inherit the PATH, BASALT_GLOBAL_REPO, and BASALT_GLOBAL_DATA_DIR.
# This file is executed by './pkg/bin/basalt-package-init'. We are able to use 'exit 1'
# since these functions must only be called in a fresh Bash context

main.basalt-package-init() {
	# Set main variables (WET)
	local basalt_global_repo="${0%/*}"
	basalt_global_repo=${basalt_global_repo%/*}; basalt_global_repo=${basalt_global_repo%/*}

	cat <<EOF
basalt.package-init() {
	# basalt variables
	export BASALT_GLOBAL_REPO="$basalt_global_repo"
EOF
	cat <<"EOF"
	export BASALT_GLOBAL_DATA_DIR="${BASALT_GLOBAL_DATA_DIR:-"${XDG_DATA_HOME:-$HOME/.local/share}/basalt"}"

	# basalt global and internal functions
	source "$BASALT_GLOBAL_REPO/pkg/src/public/basalt-global.sh"
	source "$BASALT_GLOBAL_REPO/pkg/src/public/basalt-package.sh"

	if [ -z "${BASALT_PACKAGE_DIR:-}" ]; then
		local __old_cd="$PWD"

		# Do not use "$0", since it won't work in some environments, such as Bats
		local __basalt_file="${BASH_SOURCE[0]}"
		if [ -L "$__basalt_file" ]; then
			local __basalt_target="$(readlink "$__basalt_file")"
			if ! cd "${__basalt_target%/*}"; then
				printf '%s\n' "Error: basalt.package-init: Could not cd to '${__basalt_target%/*}'"
				exit 1
			fi
		else
			if ! cd "${__basalt_file%/*}"; then
				printf '%s\n' "Error: basalt.package-init: Could not cd to '${__basalt_file%/*}'"
				exit 1
			fi
		fi

		if ! BASALT_PACKAGE_DIR="$(
			while [ ! -f 'basalt.toml' ] && [ "$PWD" != / ]; do
				if ! cd ..; then
					exit 1
				fi
			done

			if [ "$PWD" = / ]; then
				exit 1
			fi

			printf '%s' "$PWD"
		)"; then
			printf '%s\n' "Error: basalt.package-init: Could not find basalt.toml"
			if ! cd "$__old_cd"; then
				printf '%s\n' "Error: basalt.package-init: Could not cd back to '$__old_cd'"
				exit 1
			fi
			exit 1
		fi

		if ! cd "$__old_cd"; then
			printf '%s\n' "Error: basalt.package-init: Could not cd back to '$__old_cd'"
			exit 1
		fi
	fi
}
EOF
}
