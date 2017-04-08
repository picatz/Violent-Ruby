# Violent Ruby 🎻

Violent Ruby is a collection of tools for Hackers, Forensic Analysts, Penetration Testers and Security Engineers.

#### Development Notice

⚠️  Gem is still in development.

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

### FTP Brute Forcer

The ftp brute forcer can be used to to brute force your way into a server over FTP.

```ruby
require 'violent_ruby'

ftp = FtpBruteForcer.new
ftp.users     = "resources/ftp_users.txt"
ftp.ports     = "resources/ftp_ports.txt"
ftp.ips       = "resources/ftp_ips.txt"
ftp.passwords = "resources/ftp_passwords.txt"

ftp.brute_force!
# => [{:time=>2017-04-03 19:02:11 -0400, :type=>"SUCCESS", :ip=>"192.168.33.10", :port=>"21", :user=>"vagrant", :password=>"vagrant"},
# {:time=>2017-04-03 19:02:15 -0400, :type=>"FAILURE", :ip=>"192.168.33.10", :port=>"21", :user=>"vagrant", :password=>"ftp"},
# {:time=>2017-04-03 19:02:18 -0400, :type=>"FAILURE", :ip=>"192.168.33.10", :port=>"21", :user=>"vagrant", :password=>"root"}]
```

### SSH Brute Forcer

The ssh brute forcer can be used to to brute force your way into a server over SSH.

```ruby
require 'violent_ruby'

ssh = SSHBruteForcer.new
ssh.users     = "resources/ssh_users.txt"
ssh.ports     = "resources/ssh_ports.txt"
ssh.ips       = "resources/ssh_ips.txt"
ssh.passwords = "resources/ssh_passwords.txt"

ssh.brute_force do |result|
  result
  # => [{:time=>2017-04-03 19:02:11 -0400, :type=>"SUCCESS", :ip=>"192.168.33.10", :port=>"22", :user=>"vagrant", :password=>"vagrant"},
end
```
### Violent Ruby Shell

The `Violent Ruby` shell provides quick access to all of Violent Ruby in a custom Pry shell.

This is provided via a file called `python_sucks` when the gem is installed.

```ruby
$ python_sucks
🎻 (main)> scanner = VulnerabilityScanner.new
=> #<ViolentRuby::VulnerabilityScanner:0x007fc9531aab20 @known_vulnerabilities=[], @targets=[]>
🎻 (main)> scanner.targets = "127.0.0.1"
=> "127.0.0.1"
scanner.known_vulnerabilities = "MS-IIS WEB SERVER 5.0"
=> "MS-IIS WEB SERVER 5.0"
scanner.scan(ports: 80, 8080)
=> [{:ip=>"127.0.0.1", :port=>8080, :banner=>"MS-IIS WEB SERVER 5.0"}]
🎻 (main)> 
🎻 (main)> 
🎻 (main)> show-method scanner.retrieve_banner
From: /path_to_where_this_is/violent_ruby/lib/violent_ruby/vulnerability_scanner/vulnerability_scanner.rb @ line 107:
Owner: ViolentRuby::VulnerabilityScanner
Visibility: public
Number of lines: 14

def retrieve_banner(ip, port, seconds = 2)
  banner = false
  Timeout.timeout(seconds) do 
    socket = TCPSocket.new(ip, port)
    banner = socket.recv(1024)
    socket.close
  end
  return false unless banner
  banner.strip!
  yield banner if block_given?
  banner
rescue
  false
end     
🎻 (main)> help
🎻 (main)> exit
```

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

