# path setting magic for example directory only
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require "violent_ruby"
require "pry"

scanner = ViolentRuby::VulnerabilityScanner.new
scanner.targets << "127.0.0.1"
scanner.known_vulnerabilities << "banner"
scanner.scan(port: 8080)

binding.pry
