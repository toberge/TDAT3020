# OpenVPN with static key

Going by [OpenVPN's official guide for static key setup](https://openvpn.net/community-resources/static-key-mini-howto/),
I set up a simple OpenVPN server and had a classmate connect and successfully access a web server.

See the config files for some additional information.

## Server-side:

See the corresponding commands in the [Makefile](Makefile) for more details.

1. Generate a key with `make static.key`
   + This calls `openvpn --genkey --secret static.key`
2. Start openvpn with `openvpn --config server.conf`
3. Serve some HTML file with `python -m http.server 8001`
4. Set up firewall rules that allow access to the web server with `make firewall`
   + This adds some `ufw` rules for the `tun0` interface
   + (and also opens for incoming connections on port 1194)

![VPN server starting](img/vpn-server.png)

![Web server accepting request](img/webserver.png)

## Client-side:

1. Copy `client.conf` and `static.key` somewhere
2. Replace the template after `remote` with the server's external IP
3. Start openvpn with `openvpn --config client.conf`
4. Try to access `10.8.0.1:8001` -- it _should_ work

![Client pinging server and curling web page](img/ping-and-curl.png)

![VPN client connecting](img/vpn-client.png)

## Extra

See [this article](https://community.openvpn.net/openvpn/wiki/VORACLE)
for the reason why I didn't enable compression like the guide suggested.
