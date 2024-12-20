#!/bin/bash

###############################################################################
#
# Opuput NodeRED log
#
# arg1 : Method name
# arg2 : LogLevel (trace, debug, info, warn, error)
# arg3 : Message
#
###############################################################################

###############################################################################
# define
###############################################################################
# get environment variable
loglevel_env="${LogLevel}"
if [ -z "${loglevel_env}" ] ; then
    loglevel_env="info"
fi

###############################################################################
# function
###############################################################################
function convertLogLevelFromStrToNum()
{
    result=0
    level="$1"
    case "${level,,}" in
        "trace")
            result=7;;
        "debug")
            result=6;;
        "info")
            result=5;;
        "warn")
            result=4;;
        "error")
            result=3;;
        *)
            result=5;;
    esac

    return ${result}
}

###############################################################################
# main
###############################################################################
# check arguments
if [ $# != 3 ]; then
    exit 1
fi
method="$1"
loglevel_arg="$2"
message="$3"

# check loglevel
convertLogLevelFromStrToNum "${loglevel_env}"
level_env=$?
convertLogLevelFromStrToNum "${loglevel_arg}"
level_arg=$?
if [ ${level_env} -lt ${level_arg} ]; then
    exit 0
fi

# echo message
timestamp=`date '+%Y-%m-%d %H:%M:%S.%3N %z'`
if [ -n "${method}" ]; then
    method="[${method}]"
fi
echo "<${level_arg,,}> ${timestamp} ${method}${message}"

exit 0
