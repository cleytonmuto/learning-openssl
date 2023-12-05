@echo off

SET PATH=%PATH%;C:\Program Files\Git\usr\bin\openssl.exe
SET OPENSSL_CONF=C:\Program Files\Git\usr\bin\openssl.cfg

:: Create a random file with 32 bytes (256 bits):
openssl rand 32 > symmetric_keyfile.key

:: Encrypt constitution.pdf using AES algorithm (with salt) and the above key file:
openssl enc -in constitution.pdf -out constitution.pdf.enc -e -aes-256-cbc -salt -pbkdf2 -kfile symmetric_keyfile.key

:: Decrypt constitution.pdf.enc
openssl aes-256-cbc -d -pbkdf2 -in constitution.pdf.enc -out output.pdf -kfile symmetric_keyfile.key

:: Generate a RSA private key with given size:
openssl genrsa -out alice_priv.key 4096

:: Generate the public key pair:
openssl rsa -in alice_priv.key -pubout -out alice_pub.key

:: Encrypt the AES key (symmetric_keyfile.key) with the RSA public key (alice_pub.key), a.k.a. "hybrid one-way schema":
openssl pkeyutl -encrypt -inkey alice_pub.key -pubin -in symmetric_keyfile.key -out symmetric_keyfile.key.enc

:: Decrypt the AES key
openssl pkeyutl -decrypt -inkey alice_priv.key -in symmetric_keyfile.key.enc -out another_keyfile.key