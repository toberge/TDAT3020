---
title: "Assignment 13: Setting up HIDS and NIDS"
author: Tore Bergebakken
---

# HIDS

Trying out ~~AFICK~~ -- nah, I'll go with Tripwire

Creating some throwaway files in `/tmp/tamper`:

```bash
for f in /tmp/tamper/file{1..4}.bin
do
  head -n20 /dev/urandom > "$f"
done
```

Setting up some fitting policies in `/etc/tripwire/twpol.txt`:
(the default policies seem quite neat, this is just for demonstration)

```
(
  rulename = "Just 4 Testing",
  severity = $(SIG_HI)
)
{
  /tmp/tamper/                         -> $(ReadOnly);
}
```

Then generating keys, config and policy files:
(note that `$HOSTNAME` does not exist in `fish`)

```sh
twadmin --generate-keys -L /etc/tripwire/"$HOSTNAME"-local.key
twadmin --generate-keys -S /etc/tripwire/site.key
twadmin --create-cfgfile -S /etc/tripwire/site.key /etc/tripwire/twcfg.txt
twadmin --create-polfile -S /etc/tripwire/site.key /etc/tripwire/twpol.txt
```

Creating an initial state (and waiting for it to finish):

```sh
tripwire --init
```

Then checking if anything happened in the... one minute that has passed:

```sh
tripwire --check
```

Actually, something _did_ trigger a rule:

```
  Rule Name                       Severity Level    Added    Removed  Modified
  ---------                       --------------    -----    -------  --------
  ...                             ...               ...      ...      ...
* Tripwire Data Files             100               1        0        0
  ...                             ...               ...      ...      ...

Total objects scanned:  174924
Total violations found:  1
```

Purposefully tampering with the policy-indicated files:

```sh
head -n20 /dev/urandom > /tmp/tamper/file1.bin
```

Then running `tripwire --check` again, resulting in the following output:

```
  Rule Name                       Severity Level    Added    Removed  Modified
  ---------                       --------------    -----    -------  --------
* Just 4 Testing                  100               0        0        1
  ...                             ...               ...      ...      ...
* Tripwire Data Files             100               1        0        0
  ...                             ...               ...      ...      ...

Total objects scanned:  174924
Total violations found:  2
```

Tripwire did _indeed_ detect that one of the "read-only" files were changed.

With some additional tampering:

```
  Rule Name                       Severity Level    Added    Removed  Modified
  ---------                       --------------    -----    -------  --------
* Just 4 Testing                  100               0        1        3
  ...                             ...               ...      ...      ...
```

# NIDS

I chose `snort` and `fail2ban` as NIDS to try out.

+ `fail2ban` is an IPS with limited capacity
+ `snort` _can_ be an IPS depending on its configuration
  + and it has more functionality than `fail2ban`

## Snort

Snort requires signing up to get the latest registered rules. Community rules are freely available.

(and guess what, Snort has been bought by Cisco)

From their homepage:

```sh
wget https://www.snort.org/downloads/community/community-rules.tar.gz -O community-rules.tar.gz
tar -xvzf community-rules.tar.gz -C /etc/snort/rules
```

Or rather, using `pulledpork` as rule manager (which requires a bunch of perl packages from the AUR):

Uncommented some freely available rulesets `/etc/pulledpork/pulledpork.conf`,
then executed

```sh
pulledpork.pl -c /etc/pulledpork/pulledpork.conf -Pw
pulledpork.pl -c /etc/pulledpork/pulledpork.conf -P
```

to actually load the rules.

The network that will be secured should be added to the

```
ipvar HOME_NET any
```

line, and since I'm using `pulledpork` I had to comment every include _but_

```
include $RULE_PATH/snort.rules
```

...and additionally mess around with `RULE_PATH` and other variable definitions, create a blacklist and a whitelist, and so on. In the end, it did work.

### systemctl attempt

Finally starting `snort`, as an IDS:

```sh
systemctl start snort@wlp0s20f3
```

-- then requesting that a classmate run an attack against me, while viewing `snort`'s log with `systemctl status snort@wlp0s20f3`...

It did not result in any log, huh.

### directly starting snort

With an additional rule to simply see `ICMP test` in the output of `snort`:


Then starting `snort` with path to DAQ specified since it refused to start otherwise:

```
sudo snort -A console -i wlp0s20f3 -u snort -g snort -c /etc/snort/snort.conf --daq-dir /usr/lib/daq/
```

Pinging me resulted in

```
09/28-15:57:49.627973  [**] [1:10000001:1] ICMP test [**] [Priority: 0] {ICMP} 10.22.XX.XY -> 10.22.XY.YX
```

so `snort` does indeed work

**TODO** actually test it _properly_

## fail2ban

A basic config (in `/etc/fail2ban/jail.local`):

```ini
[DEFAULT]
bantime = 1d

[sshd]
enabled = true
banaction = ufw ; since I use ufw
ignoreip = <my_gosh_darn_ip> ; this is debatable
```

(the `sshd` jail needs to be _enabled_, all jails are disabled by default)

This should _ban_ any machines that try to SSH into my machine and fail.

Starting with `systemctl start fail2ban`, then requesting that a classmate tries SSHing in... (and making sure requests on port 22 is not blocked by `ufw`)

Checking the status with `fail2ban-client status sshd` gives the following:

```
Status for the jail: sshd
|- Filter
|  |- Currently failed:	1
|  |- Total failed:	6
|  `- Journal matches:	_SYSTEMD_UNIT=sshd.service + _COMM=sshd
`- Actions
   |- Currently banned:	1
   |- Total banned:	1
   `- Banned IP list:	<my classmate's IP>
```

Although... you really shouldn't need to use a password to access your machine through SSH. SSH keys would be much more secure and less prone to bruteforcing.
