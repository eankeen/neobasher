#!/usr/bin/env bats

load 'util/init.sh'


@test "without dependencies, does nothing" {
	test_util.mock_command _clone
	test_util.mock_command basher-install
	create_package "user/main"
	basher-plumbing-clone false site user/main

	run basher-plumbing-deps user/main

	assert_success ""
}

@test "installs dependencies" {
	test_util.mock_command _clone
	test_util.mock_command basher-install
	create_package "user/main"
	create_dep "user/main" "user/dep1"
	create_dep "user/main" "user/dep2"
	basher-plumbing-clone false site user/main

	run basher-plumbing-deps user/main

	assert_success
	assert_line "basher-install user/dep1"
	assert_line "basher-install user/dep2"
}