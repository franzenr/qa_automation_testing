#!/bin/bash
pcregrep -q "([^\/]+)\/\1.md" <<< "$1" # checks for the module naming pattern. 