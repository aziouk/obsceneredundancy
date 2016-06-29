#!/bin/bash

# This script installs the dependencies required for using swiftly

isyum=$(command -v yum)
isapt=$(command -v apt-get)

if [ -n "$isyum" ]
	then
		yum install python-devel
		yum install python-pip
		pip install swiftly
fi

if [ -n "$isapt" ]
	then
		apt-get install python-dev
		apt-get install python-pip
		pip install swiftly
fi
