# Unix Password Cracker

The unix password cracker provide a simple interface to crack unix passwords. As hackers do.

## Initialization

You can create a new password cracker in a few ways. You can set the `/etc/passwd` and `dictionary` file later if you want to:

### Create a new Unix Password Cracker, with a Config

```ruby
require 'violent_ruby'
config = { file: "/etc/passwd", dictionry: "dictionary.txt" }
upc = ViolentRuby::UnixPasswordCracker.new(config)
```

### Create a new Unix Password Cracker, setting stuff later

```ruby
require 'violent_ruby'
upc = ViolentRuby::UnixPasswordCracker.new
upc.file = "/etc/passwd"
upc.dictionary = "dictionary.txt"
```

## Several Ways to Crack'a Password

Because aliases are fun. You can crack passwords in a few ways.

```ruby
require 'violent_ruby'
upc = ViolentRuby::UnixPasswordCracker.new(file: "/etc/passwd", dictionry: "dictionary.txt")
upc.crack_passwords
upc.crack!
upc.get_crackn
up.release_the_kraken
```

