.PHONY: install server client

server:
	openvpn server.conf

client:
	openvpn client.conf

install:
	cp {,/etc/openvpn/server/}server.conf
	cp -r pki /etc/openvpn/server/pki
