# shellcheck shell=bash

do-add() {
	local with_ssh='no'

	local -a pkgs=()
	for arg; do
		case "$arg" in
		--ssh)
			with_ssh='yes'
			;;
		*)
			pkgs+=("$arg")
			;;
		esac
	done

	if (( ${#pkgs[@]} == 0 )); then
		die "At least one package must be supplied"
	fi

	for repoSpec in "${pkgs[@]}"; do
		util.construct_clone_url "$repoSpec" "$with_ssh"
		local uri="$REPLY1"
		local site="$REPLY2"
		local package="$REPLY3"
		local ref="$REPLY4"

		log.info "Installing '$repoSpec'"
		do-plumbing-clone "$uri" "$site/$package" $ref
		do-plumbing-add-deps "$site/$package"
		do-plumbing-link-bins "$site/$package"
		do-plumbing-link-completions "$site/$package"
		do-plumbing-link-man "$site/$package"
	done
}