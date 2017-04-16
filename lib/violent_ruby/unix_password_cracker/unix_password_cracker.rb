module ViolentRuby
  # Unix Password Cracker provides a friendly interface to
  # crack unix passwords. Because all hackers totes do this.
  # @author Kent 'picat' Gruber
  #
  # @example Basic Usage
  #   config = { file: "/etc/passwd", dictionary: "dictionary.txt" }
  #
  #   upc = ViolentRuby::UnixPasswordCracker.new(config)
  #
  #   upc.crack do |result|
  #     next unless result[:cracked]
  #     puts "Cracked #{result[:username]}'s password: #{result[:plaintext_password]}"
  #   end
  #  
  class UnixPasswordCracker
    # @!attribute file 
    #   @return [String] Path to the /etc/passwd file. 
    attr_accessor :file
    
    # @!attribute dictionary 
    #   @return [String] Path to dictionary file.
    attr_accessor :dictionary

    alias etc file

    # Create a new Unix Password Cracker.
    # 
    # @param  args [Hash]   The options to create a new Unix Password Cracker.
    # @option args [String] :file       The path to an /etc/passwd file.
    # @option args [String] :dictionary The path to a dictionry of passwords.
    #
    # @return [UnixPasswordCracker]
    def initialize(args = {})
      @file       = args[:file]       if args[:file]
      @dictionary = args[:dictionary] if args[:dictionary]
    end

    # Parse a unix /etc/passwd file into a more mangeable form.
    #
    # @example Basic Usage
    #   upc = ViolentRuby::UnixPasswordCracker.new
    #   upc.parse_etc_file(file: 'passwords.txt')
    #   # {"victim" => "HX9LLTdc/jiDE", "root" => "DFNFxgW7C05fo"}
    #
    # @example Super Advanced Usage
    #   ViolentRuby::UnixPasswordCracker.new.parse_etc_file(file: 'passwords.txt') do |user, pass|
    #     puts user + ' ' + pass
    #   end
    #   # victim HX9LLTdc/jiDE
    #   # root DFNFxgW7C05fo
    #
    # @param  args [Hash]    The options when parsing the file.
    # @option args [String]  :file      The path to an /etc/passwd file.
    # @option args [Boolean] :users     Specify that only users should be returned ( default: +false+ ).
    # @option args [Boolean] :passwords Specify that only passwords should be returned ( default: +false+ ).
    #
    # @return [Hash]
    def parse_etc_file(args = {})
      # Readlines from /etc/passwd file.
      lines = File.readlines(args[:file]).collect do |line|
        line unless line.split(':').first.chars.first.include?('#')
      end
      
      # Collect the users and passwords from the lines.
      users     = lines.collect { |x| x.split(':')[0] }.map(&:strip)
      passwords = lines.collect { |x| x.split(':')[1] }.map(&:strip)
      
      # Friendly behavior to return just users or passwords.
      return users     if args[:users]
      return passwords if args[:passwords]
      
      # Zip'm together into a hash.
      users_passwords = Hash[users.zip(passwords)]
      
      # Yield each pair when a block is given, or return all at once.
      if block_given?
        users_passwords.each do |user, password|
          yield user, password
        end
      else
        users_passwords
      end
    end

    # Crack unix passwords.
    # 
    # @example Basic Usage
    #   ViolentRuby::UnixPasswordCracker.new(file: "passwords.txt", dictionary: "dictionary.txt").crack_passwords do |result|
    #     next unless result[:cracked]
    #     puts "Cracked #{result[:username]}'s password: #{result[:plaintext_password]}"
    #   end
    #
    # @param  args [Hash]   The options when crack'n some passwords.
    # @option args [String] :file       The path to an /etc/passwd file.
    # @option args [String] :dictionary The path to a dictionry of passwords.
    #
    # @yield [Hash]
    def crack_passwords(args = {})
      # Use the file and dictionry instance variables or the arguments.
      file = args[:file]       || @file
      dict = args[:dictionary] || @dictionary
      # Parse the given /etc/passwd file and compare with the dictionary.
      parse_etc_file(file: file) do |user, password|
        File.readlines(dict).map(&:strip).each do |word|
          if cracked?(password, word)
            yield format_result(user, password, word)
            break
          else
            yield format_result(user, password)
          end
        end
      end
    end
    
    alias crack crack_passwords

    alias crack! crack_passwords

    alias get_crackn crack_passwords

    alias release_the_kraken crack_passwords 

    # Check if a given encrypted password matches a given plaintext
    # word when the same crytographic operation is performed on it.
    #
    # @example Basic Usage
    #   ViolentRuby::UnixPasswordCracker.new.check_password('HX9LLTdc/jiDE', 'egg')
    #   # true
    #
    # @example Advanced Usage
    #   ViolentRuby::UnixPasswordCracker.new.check_password('HXA82SzTqypHA', 'egg ')
    #   # false
    #   
    #   ViolentRuby::UnixPasswordCracker.new.check_password('HXA82SzTqypHA', 'egg ', false)
    #   # true 
    #
    # @param encrypted_password [String] The encrypted password to check against.
    # @param plaintext_password [String] The plaintext password to check against.
    # @param strip              [Boolean] Strip trailing spaces and newlines from word ( default: +true+ )
    #
    # @return [Boolean]
    def check_password(encrypted_password, plaintext_password, strip = true)
      plaintext_password.strip! if strip # sometimes passwords have trailing spaces
      if plaintext_password.crypt(encrypted_password[0, 2]) == encrypted_password
        true
      else
        false
      end
    end 

    alias cracked? check_password

    private

    # @api private
    # Format the results for the password crack'n.
    #
    # @param user           [String] 
    # @param encrypted_pass [String] 
    # @param plaintext_pass [String] 
    #
    # @return [Hash] 
    def format_result(user, encrypted_pass, plaintext_pass = false)
      result = {}
      if plaintext_pass
        result[:cracked] = true
      else
        result[:cracked] = false
      end
      result[:username]           = user
      result[:encrypted_password] = encrypted_pass 
      result[:plaintext_password] = plaintext_pass if plaintext_pass
      result
    end
  end
end
