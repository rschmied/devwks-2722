#!/bin/bash

while : ; do
	echo -n "Please enter your pod number (1-20): "
	read pod
	if [[ "$pod" =~ ^[0-9]+$ ]]; then 
		[ "$pod" -lt 1 -o "$pod" -gt 20 ] || break
	fi
	echo "bad input!"
done

pw=$(printf "%02ddevwks%02d" $pod $pod)

cat >.secrets <<EOF
export TF_VAR_username="pod${pod}"
export TF_VAR_password="${pw}"
EOF

source .secrets

