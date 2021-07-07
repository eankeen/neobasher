#!/usr/bin/env bats

load 'util/init.sh'

@test "list installed packages" {
	test_util.mock_command plumbing-clone
	create_package username/p1
	create_package username2/p2
	create_package username2/p3
	do-install username/p1
	do-install username2/p2

	run do-list

	assert_success
	assert_line "username2/p2"
	assert_line "username/p1"
	refute_line "username2/p3"
}

@test "displays nothing if there are no packages" {
	test_util.mock_command plumbing-clone
	create_package username/p1

	run do-list

	assert_success
	assert_output ""
}

@test "displays outdated packages" {
	test_util.mock_command plumbing-clone
	create_package username/outdated
	create_package username/uptodate
	do-install username/outdated
	do-install username/uptodate
	create_exec username/outdated "second"

	run do-list --outdated

	assert_success
	assert_output username/outdated
}