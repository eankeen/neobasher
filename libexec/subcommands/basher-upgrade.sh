#!/usr/bin/env bash
# Summary: Upgrades a package
# Usage: basher upgrade <package>

set -e

basher-upgrade() {
  if [ "$#" -ne 1 ]; then
    basher-help upgrade
    exit 1
  fi

  package="$1"

  if [ -z "$package" ]; then
    basher-help upgrade
    exit 1
  fi

  IFS=/ read -r user name <<< "$package"

  if [ -z "$user" ]; then
    basher-help upgrade
    exit 1
  fi

  if [ -z "$name" ]; then
    basher-help upgrade
    exit 1
  fi

  cd "${BASHER_PACKAGES_PATH}/$package"
  git pull
}
