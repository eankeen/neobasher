# shellcheck shell=bash

do-list() {
	local flag_outdated='no'
	local flag_simple='no'

	for arg; do
		case "$arg" in
		--simple)
			flag_simple='yes'
			;;
		esac
	done

	local has_invalid_packages='no'

	for namespace_path in "$BPM_PACKAGES_PATH"/*; do
		local glob_suffix=
		if [ "${namespace_path##*/}" = 'local' ]; then
			glob_suffix="/*"
		else
			glob_suffix="/*/*"
		fi

		for pkg_path in "$namespace_path"$glob_suffix; do
			util.extract_data_from_package_dir "$pkg_path"
			local site="$REPLY1"
			local user="$REPLY2"
			local repository="$REPLY3"

			# Users that have installed packages before the switch to namespacing by
			# site domain name will print incorrectly. So, we check to make sure the site
			# url is actually is a domain name and not, for example, a GitHub username
			if [[ "$site" != *.* ]] && [ "$site" != 'local' ]; then
				has_invalid_packages='yes'
				continue
			fi

			# Relative path location of the current package
			local id=
			if [ "$site" = 'local' ]; then
				id="$site/$repository"
			else
				id="$site/$user/$repository"
			fi

			# The information being outputed for a particular package
			# Ex.
			# github.com/tj/git-extras
			#   Status: Up to Date
			#   Branch: main\n
			local pkg_output=

			printf -v pkg_output "%s\n" "$id"

			if [ "$flag_simple" = 'no' ]; then
				if [ ! -d "$pkg_path/.git" ]; then
					die "Package '$id' is not a Git repository. Unlink or otherwise remove it at '$pkg_path'"
				fi

				local repo_branch_str= repo_outdated_str=

				repo_branch_str="Branch: $(git -C "$pkg_path" branch --show-current)"
				printf -v pkg_output "%s  %s\n" "$pkg_output" "$repo_branch_str"

				if git config remote.origin.url &>/dev/null; then
					# shellcheck disable=SC1083
					if [ "$(git -C "$pkg_path" rev-list --count HEAD...HEAD@{upstream})" -gt 0 ]; then
						if [ -n "${NO_COLOR+x}" ] || [ "$TERM" = dumb ]; then
							repo_outdated_str="State: Out of date"
						else
							printf -v repo_outdated_str "\033[1;33m%s\033[0m\n" "State: Out of date"
						fi
						repo_outdated_str="State: Out of date"
					else
						repo_outdated_str="State: Up to date"
					fi

					printf -v pkg_output "%s  %s\n" "$pkg_output" "$repo_outdated_str"
				fi
			fi

			printf "%s" "$pkg_output"
		done
	done

	if [ "$has_invalid_packages" = 'yes' ]; then
		log.error "You have invalid packages. To fix this optimally, remove the '${BPM_PACKAGES_PATH%/*}' directory and reinstall all that packages that were deleted in the process. This procedure is required in response to a one-time breaking change in how packages are stored"
	fi
}
