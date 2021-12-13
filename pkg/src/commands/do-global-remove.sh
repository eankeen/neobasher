# shellcheck shell=bash

do-global-remove() {
	util.init_global

	local flag_force='no'
	local -a pkgs=()
	for arg; do case "$arg" in
	--force)
		flag_force='yes'
		;;
	-*)
		bprint.die "Flag '$arg' not recognized"
		;;
	*)
		pkgs+=("$arg")
		;;
	esac done

	if ((${#pkgs[@]} == 0)); then
		bprint.die "Must specify at least one package"
	fi

	for pkg in "${pkgs[@]}"; do
		util.get_package_info "$pkg"
		local url="$REPLY2" version="$REPLY5"

		if [ -n "$version" ]; then
			bprint.die "Must not specify ref when removing packages"
		fi

		util.text_remove_dependency "$BASALT_GLOBAL_DATA_DIR/global/dependencies" "$url" "$flag_force"
	done

	do-global-install
}