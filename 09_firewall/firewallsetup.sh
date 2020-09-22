#!/bin/sh
#
# firewallsetup.sh

set -eu # safe mode

SQUID_PORT=3128
FW_USER=yournamehere
WL=$(ip link | grep wl | head -n 1 | cut -d ' ' -f 2 | tr -d ':') # wireless fra internett
ETH=$(ip link | grep -E '(en|eth)' | head -n 1 | cut -d ' ' -f 2 | tr -d ':') # ethernet til klientene

# flushing the iptable
iptables -F FORWARD
iptables -t nat -F

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
# Squid
#

# Let proxy (squid) user accept HTTP(S)
iptables -A OUTPUT -p tcp --dport 80 -t nat \
    -m owner --uid-owner proxy -j ACCEPT
iptables -A OUTPUT -p tcp --dport 443 -t nat \
    -m owner --uid-owner proxy -j ACCEPT

# Also let the user of this firewall machine connect to the internet
iptables -A OUTPUT -p tcp --dport 80 -t nat \
    -m owner --uid-owner "$FW_USER" -j ACCEPT
iptables -A OUTPUT -p tcp --dport 443 -t nat \
    -m owner --uid-owner "$FW_USER" -j ACCEPT

# Redirect all HTTP(S) packets to squid
iptables -A OUTPUT -p tcp --dport 80 -t nat \
    -j REDIRECT --to "$SQUID_PORT"
iptables -A OUTPUT -p tcp --dport 443 -t nat \
    -j REDIRECT --to "$SQUID_PORT"

# Miscellaneous attempts

#iptables -P FORWARD DROP # killall packages

# Regel 1:
# Blokkere google.com
# _ -d 216.58.207.206 -j REJECT # eller DROP eller LOG

# Blokkere HTTPS
# _ -p tcp --dport 443 -j REJECT

#if(url == facebook.com/atlanterhavet){dont();}

# exit 42
