#!/bin/sh

# Start with the template
cat << EOF > secrets.yaml
apiVersion: v1
kind: Secret
metadata:
  name: instana-config
  namespace: instana-agent
type: Opaque
data:
EOF

# add each config file
for FILE in config/*
do
    CFG=$(basename $FILE)
    echo "Adding $CFG"
    /bin/echo -n "  ${CFG}: " >> secrets.yaml
    # MacOS implementation of base64
    # Linux needs base64 -w 0 $FILE
    # TODO - detect OS and use correct base64 form
    base64 -i $FILE >> secrets.yaml
done

echo " "
echo "secrets.yaml written"
echo " "

