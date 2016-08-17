#!/bin/bash
set -o pipefail

function ok()
{
	echo "  OK"
}

function fail()
{
	echo "  FAIL"
	exit 1
}

services=`sv status /etc/service/*`
status=$?
if [[ "$status" != 0 || "$services" = "" || "$services" =~ down ]]; then
	fail
else
	ok
fi
