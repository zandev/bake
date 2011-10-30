#!/bin/bash

## Deps

# Auto
BAKE_require_lib shflags 'http://shflags.googlecode.com/svn/trunk/source/1.0/src/shflags' '1.0.4pre'

# Manual with callback
BAKE_require_lib other_lib/lib.sh

__REQUIRE_other_lib(){
  local tmp_dir="$(mktemp -d)"
  cd "$tmp_dir"
  wget 'http://superlib.com/otherlib/lib.tgz'
  tar xzvf 'lib.tgz'
  cd lib
  local dir="$BAKE_LIB_PATH/other_lib/2.0.1"
  mkdir -p "$dir"
  cp lib.sh "$dir"
  rm -rf "$tmp_dir"
}

## Tasks
# Declare tasks and dependencies in one shot
BAKE_task hello --depends_on clean prepare mkdirs --default

__TASK_hello(){
  echo Hello World!
}

__TASK_prepare(){
  echo Will prepare
}

__TASK_mkdirs(){
  echo Will create directories
}

__TASK_clean(){
  echo Will clean
}

BAKE_init_dependencies
BAKE_process_tasks


# invocation
# bake hello
