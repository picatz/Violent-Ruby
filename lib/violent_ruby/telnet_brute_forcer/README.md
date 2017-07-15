# Telnet Brute Forcer 

Using brute-force, you can easily try to force your way into a server with Telnet.

## Vagrantfile

In this directory, along with the ruby code and the README.md, you'll find a `Vagrantfile` which you can use to setup a VM to test out the Telnet Brute Forcer. This requires you to have [vagrant](https://www.vagrantup.com/) installed.

#### Start VM

```shell
$ pwd 
/somewhere/violent_ruby/lib/violent_ruby/telnet_brute_forcer
$ ls
README.md           Vagrantfile         telnet_brute_forcer.rb
$ vagrant up
Bringing machine 'default' up with 'virtualbox' provider...
==> default: Importing base box 'ubuntu/xenial64'...
==> ect...
```

#### SSH into VM

Very simply `vagrant ssh` will allow you to SSH into the VM to make changes or monitor the VM while brute-forcing it for blue team research.

```shell
$ vagrant ssh

Welcome to Ubuntu 16.04.2 LTS (GNU/Linux 4.4.0-64-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  Get cloud support with Ubuntu Advantage Cloud Guest:
    http://www.ubuntu.com/business/services/cloud

7 packages can be updated.
7 updates are security updates.


*** System restart required ***
ubuntu@ubuntu-xenial:~$
```

The VM should be provisioned with `telnetd`, and it should be running on port 23. Because that's fun.

#### Stop VM

If you've logged into the VM via ssh, logout and then use `vagrant destroy` to destroy the VM.

```shell
$ vagrant destroy
    default: Are you sure you want to destroy the 'default' VM? [y/N] y
==> default: Forcing shutdown of VM...
==> default: Destroying VM and associated drives...
```

## Providing Required Files

```ruby
require 'violent_ruby'

telnet = TelnetBruteForcer.new

telnet.users     = "resources/telnet_users.txt"
telnet.ports     = "resources/telnet_ports.txt"
telnet.ips       = "resources/telnet_ips.txt"
telnet.passwords = "resources/telnet_passwords.txt"
```
#### Users

A `.users` file should contain a list of telnet usernames to use.

```
anonymous
ubuntu
vagrant
root
admin
picat
```

#### Passwords

A `.passwords` file should contain a list of telnet passwords to use.

```
vagrant
kali
ubuntu
root
toor
picat
password123
```

#### IPs

A `.ips` file should contain a list of ip addresses to attempt connections on.

```
192.168.33.9
192.168.33.10
192.168.33.111
```

#### Ports

A `.ports` file should contain a list of ports to attempt connections on.

```
23
2323
```
## Brute Force'n

Once everything has been setup, we're going to be able to try start brute forcing!

```ruby
require 'violent_ruby'

telnet = TelnetBruteForcer.new

telnet.users     = "resources/telnet_users.txt"
telnet.ports     = "resources/telnet_ports.txt"
telnet.ips       = "resources/telnet_ips.txt"
telnet.passwords = "resources/telnet_passwords.txt"

results = telnet.brute_force!
```

#### Results as Json?

```
require 'violent_ruby'
require 'json'

# same setup as before ...

results = telnet.brute_force!

# but, now json!

puts results.to_json
