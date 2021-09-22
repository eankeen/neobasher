# shellcheck shell=bash

do-init() {
	if [ -e basalt.toml ]; then
		print.die "File 'basalt.toml' already exists"
	fi

	# TODO: create directories / files as well / git clone from main template repository
	cat >| basalt.toml <<-"EOF"
	[package]
	name = ''
	slug = ''
	version = ''
	authors = []
	description = ''

	[run]
	dependencies = []
	sourceDirs = []
	binDirs = []
	completionDirs = []
	manDirs = []

	[run.shellEnvironment]

	[run.setOptions]

	[run.shoptOptions]
	EOF

	print.info "Created basalt.toml"
}
