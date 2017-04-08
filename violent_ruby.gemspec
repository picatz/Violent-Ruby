# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'violent_ruby/version'

Gem::Specification.new do |spec|
  spec.name          = "violent_ruby"
  spec.version       = ViolentRuby::VERSION
  spec.authors       = ["Kent Gruber"]
  spec.email         = ["kgruber1@emich.edu"]

  spec.summary       = %q{Collection of information security tools written in Ruby.}
  spec.description   = %q{Violent Ruby is a collection of tools for Hackers, Forensic Analysts, Penetration Testers and Security Engineers.}
  spec.homepage      = "https://github.com/picatz/Violent-Ruby"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  
  spec.add_dependency 'net-ssh', '~>4.1.0'
  spec.add_dependency 'socketry', '~>0.5.1'

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
