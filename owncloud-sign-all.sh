#!/bin/sh -e
#
# Owncloud have implement a very strong integrity code policy.
# As a result, if you want to use an old module, on the new version,
# It will work, but you will have constantly an annoying warning:
# "There were problems with the code integrity check. More information..."
#
# Code signing protection is a very good feature,
# in php, sometimes, code can be compromized, then it's a really good approach.
#
# BUT,
#
# There is no reason to be stuck by Owncloud policy,
# you may have to patch some core code, some modules,
# modifying compatibility information, to continue to use old modules on new code base,
# there is no reason to be stuck by Owncloud policy !
# (otherwise, you would have taken a proprietary software, don't you think ?)
#
# This script by-pass clean way the integrity check issue:
# - create a "one-time" private key and self-signed certificate
# - sign core and apps modules
# - make your owncloud environment ready for a correct integrity scan
#
# Perform the changes/the patch you want,
# And, if you are very sure with your code base, sign it yourself !!!
#

# owncloud installation path
OCPath=/var/www/www.wareld.com/owncloud

# owncloud user (on Debian with Apache2: www-data)
OCUser=www-data

# generate a one-time private key and self-signed certificate :
openssl req -nodes -new -x509 -subj "/C=US/ST=Fake/L=CodeSigning/O=ByPass/CN=core" -days 3650  -keyout /tmp/private.key -out /tmp/cert.pem

cd $OCPath

# put your certificate and certificate chain as the expected ones :
cat /tmp/cert.pem > $OCPath/resources/codesigning/root.crt
cat /tmp/cert.pem  > $OCPath/resources/codesigning/core.crt
rm -rf $OCPath/resources/codesigning/intermediate.crl.pem

# use code signature mechanism on 'core' :
sudo -u $OCUser php occ --privateKey=/tmp/private.key --certificate=/tmp/cert.pem --path=. integrity:sign-core

# use code signature mechanism on all 'apps' modules :
for i in `ls apps/`
do
	sudo -u $OCUser php occ --privateKey=/tmp/private.key --certificate=/tmp/cert.pem --path=apps/$i integrity:sign-app
done
sudo -u $OCUser php occ integrity:check-core
