# shellcheck shell=bash

# This command is similar to 'basalt global init bash', except that it is
# only used by Bash applications (and test initialization procedures of
# bash libraries) to load in all the Basalt functions in the current shell
# context. It must be a binary rather than a function because any new
# Bash contexts won't inherit functions of previous contexts, but will inherit
# the PATH, BASALT_GLOBAL_REPO, and BASALT_GLOBAL_DATA_DIR. The path contains an
# entry for the directory containing this file, which we execute to load the
# aforementioned Basalt utility functions

basalt-package-init.main() {
	# Set main variables (WET)
	local basalt_global_repo="${0%/*}"
	basalt_global_repo="${basalt_global_repo%/*}"; basalt_global_repo="${basalt_global_repo%/*}"

	cat <<-EOF
basalt.package-init() {
   # basalt variables
   export BASALT_GLOBAL_REPO="$basalt_global_repo"
	EOF

	cat <<-"EOF"
   export BASALT_GLOBAL_DATA_DIR="${BASALT_GLOBAL_DATA_DIR:-"${XDG_DATA_HOME:-$HOME/.local/share}/basalt"}"

   # basalt global and internal functions
   source "$BASALT_GLOBAL_REPO/pkg/lib/source/basalt-load.sh"
   source "$BASALT_GLOBAL_REPO/pkg/lib/source/basalt-package.sh"

   if [ -z "$BASALT_PACKAGE_PATH" ]; then
      if ! BASALT_PACKAGE_PATH="$(
         while [ ! -f 'basalt.toml' ] && [ "$PWD" != / ]; do
            if ! cd ..; then
               return 1
            fi
         done

         if [ "$PWD" = / ]; then
            return 1
         fi

         printf '%s' "$PWD"
      )"; then
         printf '%s\n' "Error: basalt-package-init: Could not find basalt.toml"
         return 1
      fi
   fi
}
	EOF
}