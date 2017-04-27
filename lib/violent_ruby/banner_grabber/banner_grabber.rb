require 'socketry'

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
  #   BannerGrabber.new(ip: '0.0.0.0', port: 4567).grab(http: true) do |result|
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
    # @param ips   [String, Array<String>]
    # @param ports [String, Array<String>]
    # @see use_ips
    # @see use_ports
    # @return [BannerGrabber]
    def initialize(ips:, ports:)
      @ips   = use_ips(ips)   
      @ports = use_ports(ports) 
    end

    # Attempt to grab the banner. Optionally, an HTTP option
    # can help simulate HTTP GET requests to a webserver.
    # @param ips   [String, Array<String>]
    # @param ports [String, Array<String>] 
    # @param http  [Boolean]               Perform an HTTP GET request if +true+.
    # @see use_ips
    # @see use_ports
    # @yield [Hash]
    def grab(ips: false, ports: false, timeout: 2, **args)
      results = []
      use_ips(ips) do |ip|
        use_ports(ports) do |port|
          if socket = connect(ip: ip, port: port, timeout: 2)
            socket.writepartial("GET / HTTP/1.1\r\nHost:3.1.3.3.7\r\n\r\n") if args[:http]
            banner = false unless banner = socket.readpartial(1024, timeout: timeout)
          end
          if socket
            result = format_result(ip: ip, port: port, open: true, banner: banner)
            yield result if block_given?
            results << result
            socket.close
          else
            result = format_result(ip: ip, port: port)
            yield result if block_given?
            results << result
          end
        end
      end
      results
    end

    # Because sometimes you need to say it with more emphasis!
    alias grab! grab

    # Connect to a given IP address and port.
    # @param ip [String]
    # @param port [Integer]
    # @return [TCPSocket, false]
    def connect(ip:, port:, timeout:)
      Socketry::TCP::Socket.connect(ip, port, local_addr: nil, local_port: nil, timeout: timeout)
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
    def format_result(ip:, port:, open: false, banner: false)
      result          = { ip: ip, port: port }
      result[:open]   = open
      result[:banner] = banner if banner.is_a?(String) and !banner.empty?
      result
    end

    # @api private
    #
    # Determine what IP address(es) to use from a given arguments hash.
    #
    # @param ip  [String]        IP address to connect to.
    # @param ips [Array<String>] An array of IP address to connect to.
    #
    # @yield [String] Each ip if a block if given.
    # @return [Array<String>]
    #
    # @raise [ArgumentError] If no IP address(es) can be determined.
    #
    def use_ips(ips)
      results = []
      ips = @ips unless ips 
      if ips.is_a? Array
        results.push(*ips)   
      elsif ips.is_a? String
        results.push(ips)
      else
        raise ArgumentError 
      end
      results.each { |ip| yield ip } if block_given?
      results 
    end

    # @api private
    #
    # Determine what port(s) to use from a given arguments hash.
    #
    # @param port  [String]        Port to connect to. 
    # @param ports [Array<String>] An array of ports to connect to.
    #
    # @yield [String]          Each ip if a block if given.
    # @return [Array<Integer>] 
    # 
    # @raise [ArgumentError] If no port(s) can be determined.  
    def use_ports(ports)
      results= []
      ports = @ports unless ports
      if ports.is_a? Array
        results.push(*ports)   
      elsif ports.is_a? String
        results.push(ports)
      else
        raise ArgumentError
      end
      results.each { |port| yield port } if block_given?
      results
    end
  end
end
