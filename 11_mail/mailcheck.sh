#!/bin/sh

die() {
    echo "$@" 1>&2
    exit 1
}

[ -z "$1" ] && die "No domain specified"

# early version
get_mx_oneline() {
    dig +short -t mx "$1" | cut -d' ' -f2 | sed 's/.$//' \
        | tee /dev/stderr | xargs -n1 dig +short
}

get_mx() {
    # Perform dig query, strip number and trailing dot
    dig +short "$1" mx | cut -d' ' -f2 | sed 's/.$//' | {
        while read -r domain
        do # Then do a reverse lookup to get the IP address
            printf "\033[1m%s\033[0m -> " "$domain"
            dig +short "$domain"
        done
    }
}

get_spf() {
    # Perform dig query, find spf line, strip it and split it!
    dig_output=$(dig +short "$1" txt | grep spf )    
    [ -z "$dig_output" ] && return 1 # no need to process it further

    IFS=':'
    echo "$dig_output" \
        | sed -E 's/"//g;s/v=spf[^ ]* //;s/ .all//' \
        | tr ' ' '\n' | {
        while read -r type address
        do
            if [ "$type" = "include" ]
            then # Recurse! Prepend some whitespace for visibility
                printf "\033[1m%s\033[0m gives:\n" "$address"
                get_spf "$address" | sed -e 's/^/  /' \
                    || echo "  <nothing>"
            elif [ -n "$address" ] # (nonempty)
            then # This is a simple IP address. Print it.
                echo "$address"
            # (modifiers are unsplit since we split on colon)
            elif [ "${type%%=*}" = "redirect" ]
            then # It's a redirect! Abort and recurse!
                printf  "\033[1mRedirect to %s!\033[0m\n" "${type##*=}"
                get_spf "${type##*=}"
                break # gtfo
            fi
        done
    }
}

domain="$1"

# MX-info (-t mx)
# reverse lookup (-x) on the above
echo "~~~~~~~~~~~~~~~~~~"
echo "MX records and IP addresses of those domains:"
get_mx "$domain"

# addresses from spf (with includes!)
echo "~~~~~~~~~~~~~~~~~~"
echo "SPF addresses (alternative senders):"
get_spf "$domain" || printf "\033[1;31mThis server does not use SPF\033[0m\n"

echo "~~~~~~~~~~~~~~~~~~"
# + more if ya want
echo "Done."
