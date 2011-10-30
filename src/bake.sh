#!/bin/bash

###
## Environment variables

  declare BAKE_PKG_PATH

##
###

###
## Private functions

  __expect_value(){
    [ -s "$1" ] && return 1
    [[ "$1" =~ ^\ *-- ]] && return 1
    return 0
  }

##
###

###
## API

  # Retrieve a file localy or remotly a copy it into the specified directory
  # $1: the file to retrieve
  # $2: the target directory
  # $3: the protocol to use, default to http
  retrieve_lib(){
    [ -d "$2" ] || mkdir -pv "$2"
    case "${3:-http}" in
      http) wget -v "$1" -P "$2";;
      file) cp -v "$1" "$2";;
    esac
  }

  # Verify if a dependency is satisfied, or retrieve it from a local or remote location.
  # -n|--name         : the name of the library
  # -l|--location     : the location of the library
  # -w|--with-callback: a callback to handle the dependency
  # -v|--version      : the version of the library
  require_lib(){

    show_help(){
      echo $@
      exit 0
    }
    
    for var in name location callback version; do
      local $var=''
    done

    while [ $# -gt 1 ]; do
      case $1 in
        -n|--name)
          __expect_value $2 || show_help "$1 expect a valid value"
          name="$2"
          shift 2
          ;;
        -l|--location)
          __expect_value $2 || show_help "$1 expect a valid value"
          location="$2"
          shift 2
          ;;
        -w|--with)
          __expect_value $2 || show_help "$1 expect a valid value"
          callback="$2"
          shift 2
          ;;
        -v|--version)
          __expect_value $2 || show_help "$1 expect a valid value"
          version="$2"
          shift 2
          ;;
        --)
          shift 2
          ;;
        -*|*)
          show_help "Unknow parameter $1"
          ;;
      esac
    done

    local protocol="$(echo $location | egrep -o '^[a-zA-Z]+://' | sed 's@://$@@')"

    echo name is $name
    echo protocol is $protocol
    echo location is $location
    echo version is $version
    echo callback is $callback

    if [ -f "$BAKE_PKG_PATH/$name/$version/$name.sh" ]; then
      echo "Found $name in $BAKE_PKG_PATH/$name/$version"
    elif [ ! -z "$callback" ]; then
      $callback
    else
      echo "No $name found in $BAKE_PKG_PATH/$name/$version"
      retrieve_lib "$location" "$BAKE_PKG_PATH/$name/$version" "${protocol:-file}"
    fi
  }

##
###
