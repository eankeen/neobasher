#!/usr/bin/env bats

load 'util/init.sh'

@test "fails when no packages are specified" {
	test_util.mock_command do-plumbing-clone
	test_util.mock_command do-plumbing-add-deps
	test_util.mock_command do-plumbing-link-bins
	test_util.mock_command do-plumbing-link-completions
	test_util.mock_command do-plumbing-link-man

	run do-add

	assert_failure
	assert_line -n 0 -p "At least one package must be supplied"
}

@test "executes install steps in right order" {
	test_util.mock_command do-plumbing-clone
	test_util.mock_command do-plumbing-add-deps
	test_util.mock_command do-plumbing-link-bins
	test_util.mock_command do-plumbing-link-completions
	test_util.mock_command do-plumbing-link-man

	run do-add username/package

	assert_success
	assert_line -n 0 -p "Installing 'username/package'"
	assert_line -n 1 'do-plumbing-clone https://github.com/username/package.git github.com/username/package'
	assert_line -n 2 'do-plumbing-add-deps github.com/username/package'
	assert_line -n 3 'do-plumbing-link-bins github.com/username/package'
	assert_line -n 4 'do-plumbing-link-completions github.com/username/package'
	assert_line -n 5 'do-plumbing-link-man github.com/username/package'
}

@test "executes install steps in right order for multiple packages" {
	test_util.mock_command do-plumbing-clone
	test_util.mock_command do-plumbing-add-deps
	test_util.mock_command do-plumbing-link-bins
	test_util.mock_command do-plumbing-link-completions
	test_util.mock_command do-plumbing-link-man

	run do-add username/package username2/package2

	assert_success
	assert_line -n 0 -p "Installing 'username/package'"
	assert_line -n 1 'do-plumbing-clone https://github.com/username/package.git github.com/username/package'
	assert_line -n 2 'do-plumbing-add-deps github.com/username/package'
	assert_line -n 3 'do-plumbing-link-bins github.com/username/package'
	assert_line -n 4 'do-plumbing-link-completions github.com/username/package'
	assert_line -n 5 'do-plumbing-link-man github.com/username/package'
	assert_line -n 6 -p "Installing 'username2/package2'"
	assert_line -n 7 'do-plumbing-clone https://github.com/username2/package2.git github.com/username2/package2'
	assert_line -n 8 'do-plumbing-add-deps github.com/username2/package2'
	assert_line -n 9 'do-plumbing-link-bins github.com/username2/package2'
	assert_line -n 10 'do-plumbing-link-completions github.com/username2/package2'
	assert_line -n 11 'do-plumbing-link-man github.com/username2/package2'
}


@test "uses longhand (https) site to clone from, if specified" {
	test_util.mock_command do-plumbing-clone
	test_util.mock_command do-plumbing-add-deps
	test_util.mock_command do-plumbing-link-bins
	test_util.mock_command do-plumbing-link-completions
	test_util.mock_command do-plumbing-link-man

	run do-add https://gitlab.com/username/package

	assert_success
	assert_line "do-plumbing-clone https://gitlab.com/username/package.git gitlab.com/username/package"
}

@test "uses longhand (http) site to clone from, if specified" {
	test_util.mock_command do-plumbing-clone
	test_util.mock_command do-plumbing-add-deps
	test_util.mock_command do-plumbing-link-bins
	test_util.mock_command do-plumbing-link-completions
	test_util.mock_command do-plumbing-link-man

	run do-add http://gitlab.com/username/package

	assert_success
	assert_line "do-plumbing-clone http://gitlab.com/username/package.git gitlab.com/username/package"
}

@test "uses shorthand site to clone from, if specified" {
	test_util.mock_command do-plumbing-clone
	test_util.mock_command do-plumbing-add-deps
	test_util.mock_command do-plumbing-link-bins
	test_util.mock_command do-plumbing-link-completions
	test_util.mock_command do-plumbing-link-man

	run do-add site/username/package

	assert_success
	assert_line "do-plumbing-clone https://site/username/package.git site/username/package"
}

@test "uses GitHub as default site, if not specified" {
	test_util.mock_command do-plumbing-clone
	test_util.mock_command do-plumbing-add-deps
	test_util.mock_command do-plumbing-link-bins
	test_util.mock_command do-plumbing-link-completions
	test_util.mock_command do-plumbing-link-man

	run do-add username/package

	assert_success
	assert_line "do-plumbing-clone https://github.com/username/package.git github.com/username/package"
}

@test "uses ssh protocol, when specified" {
	test_util.mock_command do-plumbing-clone
	test_util.mock_command do-plumbing-add-deps
	test_util.mock_command do-plumbing-link-bins
	test_util.mock_command do-plumbing-link-completions
	test_util.mock_command do-plumbing-link-man

	run do-add --ssh username/package

	assert_success
	assert_line "do-plumbing-clone git@github.com:username/package github.com/username/package"
}

@test "uses ssh protocol, when specified (at end)" {
	test_util.mock_command do-plumbing-clone
	test_util.mock_command do-plumbing-add-deps
	test_util.mock_command do-plumbing-link-bins
	test_util.mock_command do-plumbing-link-completions
	test_util.mock_command do-plumbing-link-man

	run do-add username/package --ssh

	assert_success
	assert_line "do-plumbing-clone git@github.com:username/package github.com/username/package"
}

@test "uses ssh protocol raw, when specified" {
	test_util.mock_command do-plumbing-clone
	test_util.mock_command do-plumbing-add-deps
	test_util.mock_command do-plumbing-link-bins
	test_util.mock_command do-plumbing-link-completions
	test_util.mock_command do-plumbing-link-man

	run do-add git@github.com:username/package

	assert_success
	assert_line "do-plumbing-clone git@github.com:username/package github.com/username/package"
}

@test "uses custom version, when specified" {
	test_util.mock_command do-plumbing-clone
	test_util.mock_command do-plumbing-add-deps
	test_util.mock_command do-plumbing-link-bins
	test_util.mock_command do-plumbing-link-completions
	test_util.mock_command do-plumbing-link-man

	run do-add username/package@v1.2.3

	assert_success
	assert_line "do-plumbing-clone https://github.com/username/package.git github.com/username/package v1.2.3"
}

@test "does not use custom version, when not specified" {
	test_util.mock_command do-plumbing-clone
	test_util.mock_command do-plumbing-add-deps
	test_util.mock_command do-plumbing-link-bins
	test_util.mock_command do-plumbing-link-completions
	test_util.mock_command do-plumbing-link-man

	run do-add username/package@

	assert_success
	assert_line "do-plumbing-clone https://github.com/username/package.git github.com/username/package"
}