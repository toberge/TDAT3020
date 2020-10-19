# With more fancy key stuff

**This did not end up working**

See [this part of the how-to](https://openvpn.net/community-resources/how-to/#setting-up-your-own-certificate-authority-ca-and-generating-certificates-and-keys-for-an-openvpn-server-and-multiple-clients)
and [the Arch wiki entry for OpenVPN](https://wiki.archlinux.org/index.php/OpenVPN)
for the steps I tried to follow.

Edit `/etc/easy-rsa/vars`, then...

```sh
pacman -Syu easy-rsa
easyrsa clean-all
# Generate cert
easyrsa build-ca
# Generate certs for server and client
easyrsa build-server-full server # or asdf like I did
easyrsa build-client-full clientA
easyrsa build-client-full clientB
# Generate Diffie-Hellman params
easyrsa gen-dh
# Generate ta.key for TLS
openvpn --genkey --secret pki/ta.key
```

Of the files, these will be required to transfer:

+ `ca.crt`
+ `clientX.crt`
+ `clientX.key`
+ `ta.key`

In the server config blah blah
