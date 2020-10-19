.PHONY: all firewall clean

all: static.key firewall

static.key:
	openvpn --genkey --secret static.key

firewall:
	ufw allow in 1194/udp
	ufw allow out 1194/udp
	ufw allow in on tun0 to 10.8.0.1 port 8001 proto tcp
	ufw allow out on tun0 to any port 8001 proto tcp

clean:
	ufw delete allow in 1194/udp
	ufw delete allow out 1194/udp
	ufw delete allow in on tun0 to 10.8.0.1 port 8001 proto tcp
	ufw delete allow out on tun0 to any port 8001 proto tcp

static-key-vpn.pdf: README.md
	pandoc README.md -o static-key-vpn.pdf --from markdown --template eisvogel --listings
