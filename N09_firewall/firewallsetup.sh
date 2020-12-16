#!/bin/sh
#
# firewallsetup.sh

set -eu # safe mode

SQUID_PORT=3128
FW_USER=qualitanty
WL=$(ip link | grep wl | head -n 1 | cut -d ' ' -f 2 | tr -d ':') # wireless fra internett
ETH=$(ip link | grep -E '(en|eth)' | head -n 1 | cut -d ' ' -f 2 | tr -d ':') # ethernet til klientene

# flushing the iptable
# iptables -F FORWARD
# iptables -t nat -F

# iptables -i "$IN" -o "$ETH"
_() { iptables -A FORWARD -o "$ETH" "$@"; }

# Don't run this if you've set "Mode: Shared to other computers" in Network Manager
# Wether it works or not is uncertain
routing_setup() {
    echo 1 > /proc/sys/net/ipv4/ip_forward

    iptables -t nat -A POSTROUTING -o "$WL" -j MASQUERADE
    iptables -A FORWARD -i "$WL" -o "$ETH" -m state --state RELATED,ESTABLISHED -j ACCEPT
    iptables -A FORWARD -i "$ETH" -o "$WL" -j ACCEPT
}

#
# Squid (does not work)
#

# Redirect all HTTP(S) packets to squid
iptables -I OUTPUT -p tcp --dport 80 -t nat \
    -j REDIRECT --to "$SQUID_PORT"
iptables -I OUTPUT -p tcp --dport 443 -t nat \
    -j REDIRECT --to "$SQUID_PORT"

# Let proxy (squid) user accept HTTP(S)
iptables -I OUTPUT -p tcp --dport 80 -t nat \
    -m owner --uid-owner proxy -j ACCEPT
iptables -I OUTPUT -p tcp --dport 443 -t nat \
    -m owner --uid-owner proxy -j ACCEPT

# Also let the user of this firewall machine connect to the internet
iptables -I OUTPUT -p tcp --dport 80 -t nat \
    -m owner --uid-owner "$FW_USER" -j ACCEPT
iptables -I OUTPUT -p tcp --dport 443 -t nat \
    -m owner --uid-owner "$FW_USER" -j ACCEPT

# Also let root of this firewall machine connect to the internet
iptables -I OUTPUT -p tcp --dport 80 -t nat \
    -m owner --uid-owner root -j ACCEPT
iptables -I OUTPUT -p tcp --dport 443 -t nat \
    -m owner --uid-owner root -j ACCEPT

# Miscellaneous attempts

# Block javabok.no, datakom.no etc.
iptables -I FORWARD -d 129.241.162.40 -j REJECT
# Block, uh, tisip.org
iptables -I FORWARD -d 66.96.149.1 -j REJECT

# Block HTTPS
iptables -I FORWARD -p tcp --dport 443 -j REJECT

# Block HTTP (which is a lot more sensible)
iptables -I FORWARD -p tcp --dport 80 -j REJECT

#iptables -P FORWARD DROP # killall packages

# Regel 1:
# Blokkere google.com
# iptables -I FORWARD -d 216.58.207.206 -j REJECT # eller DROP eller LOG
# which is impossible

# Blokkere HTTPS
# _ -p tcp --dport 443 -j REJECT

#if(url == facebook.com/atlanterhavet){dont();}

# exit 42
