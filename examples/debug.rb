# path setting magic for example directory only
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require "violent_ruby"
require "pry"

binding.pry
