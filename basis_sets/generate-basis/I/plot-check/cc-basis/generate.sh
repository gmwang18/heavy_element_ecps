#!/usr/bin/env bash

HOME=`pwd`

declare -a basis=("DZ" "TZ" "QZ" "5Z" "6Z")

for i in "${basis[@]}"

do
	filename=$(echo "${i}" | tr '[:upper:]' '[:lower:]')
	sed "s/XZ/${i}/" template.com > $filename.com
done
