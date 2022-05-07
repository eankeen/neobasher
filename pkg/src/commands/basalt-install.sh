# shellcheck shell=bash

basalt-install() {
	util.init_local

	if (($# != 0)); then
		print.die 'No arguments or flags must be specified'
	fi

	if ! rm -rf "$BASALT_LOCAL_PROJECT_DIR/.basalt"; then
		print.die "Could not remove local '.basalt' directory"
	fi

	# 'basalt.toml' is guaranteed to exist due to 'util.init_local'
	if util.get_toml_array "$BASALT_LOCAL_PROJECT_DIR/basalt.toml" 'dependencies'; then
		local -a dependencies=("${REPLY[@]}")
		pkg.install_packages "$BASALT_LOCAL_PROJECT_DIR" 'strict' "${dependencies[@]}"
		pkg.phase_local_integration_recursive "$BASALT_LOCAL_PROJECT_DIR" 'yes' 'strict' "${dependencies[@]}"
	fi
	pkg.phase_local_integration_nonrecursive "$BASALT_LOCAL_PROJECT_DIR"
}
