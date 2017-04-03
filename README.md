# Violent Ruby 🎻

Violent Ruby is a collection of tools for Hackers, Forensic Analysts, Penetration Testers and Security Engineers.

## Installation

    $ gem install violent_ruby

## Usage

```ruby
require 'violent_ruby'
```

### Vulnerability Scanner

The vulnerability scanner is a banner grabber that can check banners on ports and check if they're known to be vulnerable. However, you will need to provide the list of known vulnerable banners yourself.
```ruby
require 'violent_ruby'

scanner = ViolentRuby::VulnerabilityScanner.new
scanner.targets = "127.0.0.1"
scanner.known_vulnerabilities = "MS-IIS WEB SERVER 5.0"
scanner.scan(ports: 80, 8080)
# => [{:ip=>"127.0.0.1", :port=>8080, :banner=>"MS-IIS WEB SERVER 5.0"}]
```

### Unix Password Cracker

The unix password cracker provide a simple interface to crack unix passwords. As hackers do.
```ruby
require 'violent_ruby'

password_cracker = ViolentRuby::UnixPasswordCracker.new
password_cracker.file = "resources/etc_passwd_file"
password_cracker.dictionary = "resources/dictionary.txt"
password_cracker.crack!
# => [{:username=>"victim", :encrypted_password=>"HX9LLTdc/jiDE", :plaintext_password=>"egg"}]
```

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

