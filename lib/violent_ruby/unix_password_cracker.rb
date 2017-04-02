module ViolentRuby
  # Unix Password Cracker provides a friendly interface to
  # crack unix passwords. Because all hackers totes do this.
  # @author Kent 'picat' Gruber
  #
  # == Create a new Unix Password Cracker
  # In order for the password cracker to work, we're going to need a +dictionary+,
  # and an /etc/passwd +file+ we want to crack.
  #
  # @example Basic Usage
  #   config = { file: "/etc/passwd", dictionry: "dictionary.txt" }
  #   upc = ViolentRuby::UnixPasswordCracker.new(config)
  #   upc.crack! 
  class UnixPasswordCracker
    # @attr [String] file Path to /etc/passwd file.
    attr_accessor :file
    # @attr [String] dictionary Path to dictionary file.
    attr_accessor :dictionary

    # Create a new Unix Password Cracker.
    #
    # @param [Hash] args The options to create a new Unix Password Cracker.
    # @param args [String] :file The path to an /etc/passwd file.
    # @param args [String] :dictionary The path to a dictionry of passwords.
    def initialize(args = {})
      if args[:file] && File.readable?(args[:file])
        @file        = args[:file]
        @credentials = parse_etc_file(file: args[:file])
      end
      return unless args[:dictionary]
      return unless File.readable?(args[:dictionary])
      @dictionary = args[:dictionary]
    end

    # Parse a unix /etc/passwd file into a more mangeable form.
    #
    # @param [Hash] args The options when parsing the file.
    # @param args [String] :file The path to an /etc/passwd file.
    # @param args [Boolean] :users Specify that only users should be returned ( default: +false+ ).
    # @param args [Boolean] :passwords Specify that only passwords should be returned ( default: +false+ ).
    # @return [Hash]
    def parse_etc_file(args = {})
      raise 'No /etc/passwd file given.' unless args[:file]
      raise "File #{args[:file]} not readable!" unless File.readable?(args[:file])
      lines = File.readlines(args[:file]).collect do |line|
        line unless line.split(':').first.chars.first.include?('#')
      end
      users = lines.collect { |x| x.split(':')[0] }.map(&:strip)
      return users if args[:users]
      passwords = lines.collect { |x| x.split(':')[1] }.map(&:strip)
      return passwords if args[:passwords]
      users_passwords = Hash[users.zip(passwords)]
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
    # @param [Hash] args The options when crack'n some passwords.
    # @param args [String] :file The path to an /etc/passwd file.
    # @param args [String] :dictionary The path to a dictionry of passwords.
    # @return [Array<Hash>]
    def crack_passwords(args = {})
      file = args[:file]       || @file
      dict = args[:dictionary] || @dictionary
      results = []
      parse_etc_file(file: file) do |user, password|
        File.readlines(dict).map(&:strip).each do |word|
          results << format_result(user, password, word) if cracked?(password, word)
        end
      end
      results
    end

    alias crack! crack_passwords

    alias get_crackn crack_passwords

    alias release_the_kraken crack_passwords 

    # Check if a given encrypted password matches a given plaintext
    # word when the same crytographic operation is performed on it.
    #
    # @param [String] encrypted_password The encrypted password to check against.
    # @param [String] word The plaintext password to check against.
    # @return [Boolean]
    def check_password(encrypted_password, word)
      if word.strip.crypt(encrypted_password[0, 2]) == encrypted_password
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
    # @param [String] user
    # @param [String] encrypted_pass
    # @param [String] plaintext_pass 
    # @return [Hash] 
    def format_result(user, encrypted_pass, plaintext_pass)
      { username: user, encrypted_password: encrypted_pass, plaintext_password: plaintext_pass } 
    end
  end
end
