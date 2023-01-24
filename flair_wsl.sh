#!/bin/bash
if [ -z "$DISPLAY" ]; then
    # $DISPLAY is not yet defined

    # Trying to determine WSL version
    uname=$(uname -r)

    if [ $(echo ${uname} | grep "Microsoft") ]; then
        # WSL version 1 found
        export DISPLAY=:0
    elif [ $(echo ${uname} | grep "microsoft-standard") ]; then
        # WSL version 2 found - Check for WSLg
        if [ $(wsl.exe --version | iconv -f UTF16 | tr -d '\r' | grep "WSLg") ]; then
            export DISPLAY=:0
        else
            export DISPLAY=$(grep nameserver /etc/resolv.conf | sed 's/nameserver //'):0
        fi
    fi
fi
