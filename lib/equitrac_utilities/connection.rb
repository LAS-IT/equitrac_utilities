require 'net/ssh'
require 'timeout'
require 'equitrac_utilities/user_actions'

module EquitracUtilities

  # The EquitracUtilities, makes it east to work with Equitac EQCmd.exe commands
  # @since 0.1.0
  #
  # @note You should use environment variables to initialize your server.
  class Connection

    attr_reader :hostname, :username, :servicename, :eqcmd_path, :ssh_options

    include EquitracUtilities::UserActions

    # Make connection to the Equitrac server
    # @note Hostname, Username and Servicename are required
    # @param params [Hash] The server configuration parameters. Options available `:hostname`, `:username`, `:servicename`, `:eqcmd_path`, `:ssh_options`
    def initialize(params={})
      config = defaults.merge(params)
      @hostname    = config[:hostname]
      @username    = config[:username]
      @servicename = config[:servicename]
      @eqcmd_path  = config[:eqcmd_path]
      @ssh_options = config[:ssh_options]

      raise ArgumentError, 'hostname missing'    if hostname.nil? or hostname.empty?
      raise ArgumentError, 'username missing'    if username.nil? or username.empty?
      raise ArgumentError, 'servicename missing' if servicename.nil? or servicename.empty?
    end

    # @note Run a command against the Equitrac server
    #
    # @param command [Symbol] choose command to perform these include: :user_query, :user_exists? (t/f), :user_add, :user_delete, :user_lock, :user_unlock, :user_modify
    # @param attributes [Hash] attributes needed to perform command
    # @return [String] the restult from the ssh command
    def run(command:, attributes:)
      unless attributes[:user_id].nil? or attributes[:user_id].empty? or attributes[:user_id].eql? ''
        # Prep command
        action  = send(command, attributes)
        ssh_cmd = build_full_command(action)
        # Execute command
        answer = send_eqcmd(ssh_cmd)
        # Post processing answer
        return post_processing(command, answer)
      end
      return "user_id missing -- #{attributes}"
    end

    private

    def build_full_command(action)
      # sample:
      "#{eqcmd_path} -s#{servicename} #{action}"
    end

    def send_eqcmd(command)
      output = nil
      # quicker timeout config - https://gist.github.com/makaroni4/8792775
      # Timeout::timeout(10) do
        Net::SSH.start(hostname, username, ssh_options) do |ssh|
          # Capture all stderr and stdout output from a remote process
          output = ssh.exec!(command)
        end
      # end
      # EQ56 returns unicode jibberish & looks like
      # "C\u0000a\u0000n\u0000'\u0000t\u0000 \u0000f\u0000i\u0000n\u0000d"
      convert_eq56_unicode_to_ascii(output)
    end

    # Clean return from ssh execution
    #
    # @param string [String] the string that need to be clean
    # @return [String] the clean string
    def convert_eq56_unicode_to_ascii(string)
      string.gsub("\u0000",'').gsub(/\\/,'')
    end

    def post_processing(command, answer)
      return process_user_exists?(answer) if command.eql? :user_exists?
      answer
    end

    def defaults
      { hostname: ENV['EQ_HOSTNAME'],
        username: ENV['EQ_USERNAME'],
        servicename: ENV['EQ_SERVICENAME'],
        eqcmd_path: ( ENV['EQ_EQCMD_PATH'] || 'C:\Program Files\Equitrac\Express\Tools\EQCmd.exe' ),
        ssh_options: (eval(ENV['EQ_SSH_OPTIONS'].to_s) || {}) }
    end
  end
end
