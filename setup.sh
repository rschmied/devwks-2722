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
export TF_VAR_address="https://cml.mine.nu"
export TF_VAR_username="pod${pod}"
export TF_VAR_password="${pw}"
export PATH=${HOME}/.local/bin:${PATH}
EOF

# change the PaTTY port so that it's unique per pod
port=$(( 2000 + $pod ))
sed -i'-orig' -e '/pat:xxxx:22$/s/xxxx/'$port'/' micro.yaml
sed -i'-orig' -e '/"pat:xxxx:22"/s/xxxx/'$port'/' solution/main.tf

echo "Your CML USERNAME is pod${pod}"
echo "Your CML PASSWORD is ${pw}"
echo "You need to source the environment using 'source .env'"

