#!/bin/bash

while :; do
    echo -n "Please enter your pod number (1-20): "
    read pod
    if [[ "$pod" =~ ^[0-9]+$ ]]; then
        [ "$pod" -lt 1 -o "$pod" -gt 20 ] || break
    fi
    echo "bad input!"
done

pw=$(printf "%02dDevWks%02d" $pod $pod)
user=$(printf "pod%d" $pod)

SERVERS=(
    "https://cml.mine.nu"
    # "https://cml2.mine.nu"
)
count=${#SERVERS[@]}
srv=${SERVERS[$(($pod % $count))]}

cat >.env <<EOF
export TF_VAR_address="${srv}"
export TF_VAR_username="${user}"
export TF_VAR_password="${pw}"
export PATH=${HOME}/.local/bin:${PATH}
EOF

# change the PaTTY port so that it's unique per pod (not used)
# port=$((2000 + $pod))
# sed -i'-orig' -e '/pat:xxxx:22$/s/xxxx/'$port'/' micro.yaml
# sed -i'-orig' -e '/"pat:xxxx:22"/s/xxxx/'$port'/' solution/main_with_tags.tf

GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo
echo -e "CML USERNAME is\t ${GREEN}${user}${NC}"
echo -e "CML PASSWORD is\t ${GREEN}${pw}${NC}"
echo -e "CML UI URL is\t ${GREEN}${srv}${NC}"
echo
echo "You need to source the environment using 'source .env'"
