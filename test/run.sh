#!/bin/bash
set -e
set -u

###
## script/dir names

  pushd $(dirname $(readlink -f "$BASH_SOURCE")) > /dev/null
  readonly script_dir="$PWD"
  popd > /dev/null
  readonly script_name=$(basename $0)

##
###

###
## Prepare

  trap _clean EXIT

  tmp_dir="$(mktemp -d)"
  stub_dir="$tmp_dir/stub"
  data_dir="$script_dir/data"

##
###

. "$script_dir/../src/bake.sh"


# api wish

BAKE_PKG_PATH="$stub_dir/lib"

require_lib testlib "$data_dir/testlib.sh" '1.0.0'
require_lib shflags "http://shflags.googlecode.com/svn/trunk/source/1.0/src/shflags" '1.0.4pre'

###
## Clean

  _clean(){
    rm -rfv "$tmp_dir"
  }

##
###
