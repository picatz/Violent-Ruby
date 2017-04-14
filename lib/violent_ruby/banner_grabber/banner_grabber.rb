require 'socket'

module ViolentRuby
  # This Banner Grabber class is meant to provide a simple
  # interface to, well... grab banners from services running
  # on a target to determine the potential attack vectors
  # avaialable to you.
  # @author Kent 'picat' Gruber
  #
  # @example Basic Usage
  #   BannerGrabber.new(ip: 'localhost', port: 22).grab do |result|
  #     puts result
  #     # => {:ip=>"localhost", :port=>22, :open=>false}
  #   end
  #
  # @example Basic Usage with HTTP Connection
  #   BannerGrabber.new(ip: '0.0.0.0', port: 4567 http: true).grab do |result|
  #     puts result
  #     # => => {:ip=>"0.0.0.0", :port=>4567, :open=>true, :banner=>""}
  #   end
  #
  # @example Advanced Usage
  #   banner_grabber = BannerGrabber.new
  #   banner_grabber.ips   = ['192.168.0.2', '192.168.0.3']
  #   banner_grabber.ports = [22, 2222]
  #   banner_grabber.grab do |result|
  #     puts result
  #     # => {:ip=>"192.168.0.2", :port=>22, :open=>true, :banner=>"SSH-2.0-OpenSSH_6.7p1 Debian-5+deb8u3\r\n"}
  #   end
  #
  class BannerGrabber
    # @attr ips [Arrray<String>, nil] Target IP Addresses.
    attr_accessor :ips
    # @attr ports [Arrray<Integer>, nil] Target ports.
    attr_accessor :ports

    # Create a new Banner Grabber. If a block if given,
    # @param args [Hash]
    # @option args [String] :ip IP address to connect to.
    # @option args [Array<String>] :ips An array of IP address to connect to.
    # @option args [Integer] :port Port to connect to.
    # @option args [Array<Integer>] :ports An array of ports to connect to.
    # @see use_ips
    # @see use_ports
    # @return [void]
    # @yield [Hash]
    def initialize(args = {})
      @ips   = use_ips(args)   if args[:ips]   || args[:ip]
      @ports = use_ports(args) if args[:ports] || args[:port]
    end

    # Attempt to grab the banner. Optionally, an HTTP option
    # can help simulate HTTP GET requests to a webserver.
    # @param args [Hash]
    # @option args [Boolean] :http Perform an HTTP GET request.
    # @see use_ips
    # @see use_ports
    # @yield [Hash]
    def grab(args = {})
      ips   = use_ips(args)
      ports = use_ports(args)
      ips.each do |ip|
        ports.each do |port|
          if socket = connect(ip, port)
            if args[:http]
              socket.puts("GET / HTTP/1.1\r\nHost:3.1.3.3.7\r\n\r\n")
            end
            unless banner = socket.recv(1024)
              banner = false
            end
          end
          if socket
            yield format_result(ip, port, true, banner)
            socket.close
          else
            yield format_result(ip, port, false)
          end
        end
      end
    end

    # Because sometimes you need to say it with more emphasis!
    alias grab! grab

    # Connect to a given IP address and port.
    # @param ip [String]
    # @param port [Integer]
    # @return [TCPSocket, false]
    def connect(ip, port)
      TCPSocket.new(ip, port)
    rescue
      false
    end

    private

    # @api private
    # Format the result for a banner grab.
    # @param ip [String] IP address associated with the result.
    # @param port [Integer] Port associated with the result.
    # @param open [Boolean] If the port/connection was open to connect to.
    # @param banner [String, Boolean] If a banner was able to be retrieved.
    # @see grab
    # @return [Hash]
    def format_result(ip, port, open = false, banner = false)
      result = { ip: ip, port: port }
      result[:open]   = open
      result[:banner] = banner if banner
      result
    end

    # @api private
    # Determine what IP address(es) to use from a given arguments hash.
    # @param args [Hash]
    # @option args [String] :ip IP address to connect to.
    # @option args [Array<String>] :ips An array of IP address to connect to.
    # @return [Array<String>]
    # @raise [StandardError] If no IP address(es) can be determined.
    def use_ips(args)
      if args[:ips]
        args[:ips]
      elsif args[:ip]
        [args[:ip]]
      elsif @ips
        @ips
      else
        raise 'No IP address(es) given!'
      end
    end

    # @api private
    # Determine what port(s) to use from a given arguments hash.
    # @param args [Hash]
    # @option args [Integer] :port Port to connect to.
    # @option args [Array<Integer>] :ports An array of ports to connect to.
    # @return [Array<Integer>]
    # @raise [StandardError] If no ports(s) can be determined.
    def use_ports(args)
      if args[:ports]
        args[:ports]
      elsif args[:port]
        [args[:port]]
      elsif @ports
        @ports
      else
        raise 'No port(s) given!'
      end
    end
  end
end
