# HTTP Brute Forcer 

HTTP brute-forcer is used to brute force basic HTTP authentication as specified in [RFC2617](www.ietf.org/rfc/rfc2617.txt)

## Initialization

```ruby
require 'violent_ruby'

h = HTTPBruteForcer.new
```

## Providing Required Files

```ruby
require 'violent_ruby'

h = HTTPBruteForcer.new

h.users     = "resources/users.txt"
h.ports     = "resources/ports.txt"
h.ips       = "resources/ips.txt"
h.passwords = "resources/passwords.txt"
```

## Providing required arrays

```ruby
require 'violent_ruby'

h = HTTPBruteForcer.new

h.users = ["user"]
h.passwords = ["1234567", "password"]
h.ips = ["313.24.53.64"]
h.ports = ["80", "90"]
```

#### Users

A `.users` file should contain a list of http usernames to use.

```
anonymous
http
vagrant
root
admin
picat
```

#### Passwords

A `.passwords` file should contain a list of http passwords to use.

```
vagrant
http
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

h = HTTPBruteForcer.new

h.users     = "resources/users.txt"
h.ports     = "resources/ports.txt"
h.ips       = "resources/ips.txt"
h.passwords = "resources/passwords.txt"

results = h.brute_force!
results
```
