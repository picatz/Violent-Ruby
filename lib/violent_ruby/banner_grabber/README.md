# Vulnerability Scanner

The vulnerability scanner class provides a simple way to check if service banners match a list of known vulnerabilities.

## Initialization

The Vulnerability Scanner scanner class can be setup in a few flexible ways.

### Basic Setup

Provide no targets, ip addresses or ports.

```ruby
require 'violent_ruby'
banner_grabber = ViolentRuby::BannerGrabber.new
```

### Provide Some IP Addresses with Setup

```ruby
require 'violent_ruby'
banner_grabber = ViolentRuby::BannerGrabber.new(ips: ['10.0.0.2', '10.0.0.3'])
```

```ruby
require 'violent_ruby'
banner_grabber = ViolentRuby::BannerGrabber.new(ip: '10.0.0.2')
```

```ruby
require 'violent_ruby'
banner_grabber = ViolentRuby::BannerGrabber.new
banner_graber.ips = ['10.0.0.2', '10.0.0.3']
```

### Provide Some Ports with Setup

```ruby
require 'violent_ruby'
banner_grabber = ViolentRuby::BannerGrabber.new(ports: [22, 2222])
```

```ruby
require 'violent_ruby'
banner_grabber = ViolentRuby::BannerGrabber.new(port: 2222)
```

```ruby
require 'violent_ruby'
banner_grabber = ViolentRuby::BannerGrabber.new
banner_grabber.ports = [22, 2222]
```

## Banner Grabbing

```ruby
require 'violent_ruby'
banner_grabber = ViolentRuby::BannerGrabber.new(ip: 'localhost', port: 2222)
banner_grabber.grab do |result|
  # do something with result
  ip_address = result[:ip]
  port       = result[:port]
  banner     = result[:banner]
  puts "#{ip}:#{port} --> #{banner}" if result[:open] and result[:banner]
end
```
