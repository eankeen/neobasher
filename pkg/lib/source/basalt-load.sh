# shellcheck shell=bash

# This function is usable by anyone to source some or all functions of a Bash
# library

# TODO: if BASALT_INTERNAL_DID_BASALT_INIT is set and --global is specified, fail

basalt.load() {
	local __basalt_flag_global='no'
	local __basalt_flag_dry='no'

	for arg; do case "$arg" in
	--global|-g)
		__basalt_flag_global='yes'
		shift
		;;
	--dry)
		# TODO: implement dry
		__basalt_flag_dry='yes'
		shift
		;;
	--help|-h)
		cat <<-"EOF"
		basalt-load: Load a particular file

		Usage:
		  basalt-load [flags] <package> [file]

		Flags:
		  --global
		    Use packages installed globally, rather than local packages

		  --dry
		    Only print what would have been sourced

		  --help
		    Print help menu

		Example:
		  basalt-load --global 'github.com/rupa/z' 'z.sh'
		  basalt-load 'github.com/ztombol/bats-assert'
		EOF
		return
		;;
	-*)
		printf '%s\n' "Error: basalt-load: Flag '$arg' not recognized"
		return 1
		;;
	esac done

	local __basalt_pkg_path="${1:-}"
	local __basalt_file="${2:-}"

	if [ -z "$__basalt_pkg_path" ]; then
		printf '%s\n' "Error: basalt-load: Missing package as first parameter"
		return 1
	fi

	if [ "$__basalt_flag_global" = 'yes' ]; then
		# TODO
		:
	else
		# If 'package' is an absoluate path, we can skip to executing the file
		if [ "${__basalt_pkg_path::1}" = / ]; then
			if [ -f "$__basalt_pkg_path/load.bash" ]; then
				# Load package (WET)
				unset basalt_load
				source "$__basalt_pkg_path/load.bash"

				if declare -f basalt_load &>/dev/null; then
					basalt_load
					unset basalt_load
				fi
			fi

			return
		fi

		# Assume can only have one version of a particular package for direct dependencies
		local __basalt_load_package_exists='no' __basalt_did_run_source='no'
		local __basalt_actual_pkg_path=
		for __basalt_actual_pkg_path in "$BASALT_PACKAGE_PATH/basalt_packages/packages/$__basalt_pkg_path"*; do
			if [ "$__basalt_load_package_exists" = yes ]; then
				printf '%s\n' "Error: basalt-load: There are multiple direct dependencies for package '$__basalt_pkg_path'. This should not happen"
				return 1
			else
				__basalt_load_package_exists='yes'
			fi

			if [ -n "$__basalt_file" ]; then
				if [ -f "$__basalt_actual_pkg_path/$__basalt_file" ]; then
					source "$__basalt_actual_pkg_path/$__basalt_file"
					__basalt_did_run_source='yes'
				else
					printf '%s\n' "Error: basalt-load: File '$__basalt_file' not found in package '$__basalt_pkg_path'"
					return 1
				fi
			elif [ -f "$__basalt_actual_pkg_path/load.bash" ]; then
				# Load package (WET)
				unset basalt_load
				source "$__basalt_actual_pkg_path/load.bash"

				if declare -f basalt_load &>/dev/null; then
					basalt_load
					unset basalt_load
				fi

				__basalt_did_run_source='yes'
			fi
		done

		if [ "$__basalt_did_run_source" = 'no' ]; then
			printf '%s\n' "Warning: basalt-load: Nothing was sourced when calling 'basalt-load $*'. Is the package actually installed?"
		fi

		unset __basalt_actual_pkg_path
	fi
}
