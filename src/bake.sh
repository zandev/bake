#!/bin/bash

###
## Environment variables

  declare BAKE_PKG_PATH

##
###

# Retrieve a file localy or remotly a copy it into the specified directory
# $1: The file to retrieve
# $2: The target directory
# $3: The protocol to use, default to http
retrieve_file(){
  [ -d "$2" ] || mkdir -pv "$2"
  case "${3:-http}" in
    http) wget -v "$1" -P "$2";;
    file) cp -v "$1" "$2";;
  esac
}

require_lib(){
  echo "$# args"
  local name="$1"
  local protocol="$(echo $2 | egrep -o '^[a-zA-Z]+://' | sed 's@://$@@')"
  local location="$2"
  local version="$3"

  echo name is $name
  echo protocol is $protocol
  echo location is $location
  echo version is $version

  if [ -f "$BAKE_PKG_PATH/$name/$version/$name.sh" ]; then
    echo "Found $name in $BAKE_PKG_PATH/$name/$version"
  else
    echo "No $name found in $BAKE_PKG_PATH/$name/$version"
    retrieve_file "$location" "$BAKE_PKG_PATH/$name/$version" "${protocol:-file}"
  fi
}
