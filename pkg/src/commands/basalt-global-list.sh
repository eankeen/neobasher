# shellcheck shell=bash

basalt-global-list() {
	util.init_global

	if (($# != 0)); then
		print.die "No arguments or flags must be specified"
	fi

	printf '%s\n' "$(<"$BASALT_GLOBAL_DATA_DIR/global/dependencies")"
}
