# owncloud-self-signed
Within Owncloud, use the code signing integrity features, without integrity check issues

Owncloud have implement a very strong integrity code policy. As a result, if you want to use an old module, on the new version, it will work, but you will have constantly an annoying warning:
"There were problems with the code integrity check. More information..."

![Code integrity notification](https://doc.owncloud.org/server/9.0/admin_manual/_images/code-integrity-notification.png)

Code signing protection is a very good feature, since in php, sometimes, code can be compromized, then it's a really good approach.

BUT,

There is no reason to be stuck by Owncloud signing policy, you may have to patch some core code, some modules, modifying compatibility information, to continue to use old modules on new code base...

No reason to be stuck by Owncloud policy !
(otherwise, you would have taken a proprietary software, don't you think ?)

This script by-pass clean way the integrity check issue:
- create a "one-time" private key and self-signed certificate
- sign core and apps modules
- make your owncloud environment ready for a correct integrity scan

Perform the changes/the patch you want, and once you are very sure with your code base, sign it yourself with this script !!!

Edit OCPath and OCUser variables, and
```
sh ./owncloud-sign-all.sh
```
Happy Open Source use.
