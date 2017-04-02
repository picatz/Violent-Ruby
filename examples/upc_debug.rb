# path setting magic for example directory only
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require "violent_ruby"
require "pry"

password_cracker = ViolentRuby::UnixPasswordCracker.new
password_cracker.file = "resources/etc_passwd_file"
password_cracker.dictionary = "resources/dictionary.txt"

binding.pry
