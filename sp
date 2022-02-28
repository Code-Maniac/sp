#!/bin/bash

help()
{
    echo "Usage:" ${BASH_SOURCE[0]} "FILE1 FILE2"
    echo "Swap FILE1 and FILE2"
}

# if help then print help. otherwise continue
while getopts ":h" option; do
    case $option in
        h) # display help
            help
            exit;;
    esac
done

# simple file swapping script
# moves $1 to temp
# moves $2 to $1
# moves temp to $2
if [[ $# -ge 2 ]]; then

    # must have a minimum of 2 arguments
    FILE1=$1
    FILE2=$2

    # ensure that both FILE1 and FILE2 are present
    if [[ ! -f ${FILE1} ]]; then
        echo ${FILE1} 'does not exist'
        exit 1
    fi
    if [[ ! -f ${FILE2} ]]; then
        echo ${FILE2} 'does not exist'
        exit 1
    fi

    # get a tempfile
    TEMPFILE=$(mktemp)

    # now do the swap
    if ! mv ${FILE1} ${TEMPFILE}; then
        echo 'Could not move ${FILE1} to temporary location'
        exit 1
    elif ! mv ${FILE2} ${FILE1}; then
        echo 'Could not move ${FILE2} to ${FILE1}'
        # move temp file back to it's original position
        mv ${TEMPFILE} ${FILE1}
        exit 1
    elif ! mv ${TEMPFILE} ${FILE2}; then
        echo 'Could not move ${FILE1} to ${FILE2}'
        # here we've gone a bit far so what should I do?
        exit 1
    fi

    # everything was successful
    exit 0
else
    echo 'Swap requires 2 arguments <FILE1> <FILE2>'
    exit 1
fi
