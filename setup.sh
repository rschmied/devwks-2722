#!/bin/bash

while : ; do
	echo -n "Please enter your pod number (1-20): "
	read pod
	if [[ "$pod" =~ ^[0-9]+$ ]]; then 
		[ "$pod" -lt 1 -o "$pod" -gt 20 ] || break
	fi
	echo "bad input!"
done

pw=$(printf "%02dDevWks%02d" $pod $pod)

cat >.env <<EOF
export TF_VAR_username="pod${pod}"
export TF_VAR_password="${pw}"
export PATH=${HOME}/.local/bin:${PATH}
EOF

echo "Your CML USERNAME is pod${pod}"
echo "Your CML PASSWORD is ${pw}"
echo "You need to source the environment using 'source .env'"

