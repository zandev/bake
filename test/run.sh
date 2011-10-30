#!/bin/bash

#set -e
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

###
## stubs

  otherlib_callback(){
    echo callback called!
  }

##
###

# api wish

BAKE_PKG_PATH="$stub_dir/lib"

# require_lib 'n:l:w:v:'
# require_lib -n(name) -l(location) -w(with callback) -v(version)
require_lib -n testlib  -l "$data_dir/testlib.sh" -v '1.0.0'
require_lib -n shflags  -l "http://shflags.googlecode.com/svn/trunk/source/1.0/src/shflags" -v '1.0.4pre'
require_lib -n otherlib -w  otherlib_callback #Handle dep manualy. Should return 0

###
## Clean

  _clean(){
    rm -rfv "$tmp_dir"
  }

##
###
