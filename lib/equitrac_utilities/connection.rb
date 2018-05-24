require 'net/ssh'
require 'timeout'
require 'equitrac_utilities/user_commands'

module EquitracUtilities
  # The Equitrac server definition, handling communication with the server.
  # @since 0.1.0
  #
  # @note If the password is define in the object, it will be included automatically into the options.
  # @note You can also use environment variables to initialize your server.
  #
  # @!attribute [r] eqcmd_path
  #   @return [String] The path where Equitrac utilities is installed
  # @!attribute [r] service_name
  #   @return [String] The name of the Equitrac service.
  class Connection

    attr_reader :hostname, :username, :servicename, :eqcmd_path, :ssh_options

    include EquitracUtilities::UserCommands

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

    def run(command:, attributes:)
      # Prep command
      cmd = send(command, attributes)
      # Execute command
      answer = send_eqcmd(cmd)
      # Post processing answer
      case command
      when :user_exists?
        return process_user_exists?(answer)
      else
        return answer
      end
    end

    private
    def send_eqcmd(cmd)
      output = nil
      ssh_cmd = "#{eqcmd_path} -s#{servicename} #{cmd}"
      # quicker timeout config - https://gist.github.com/makaroni4/8792775
      Timeout::timeout(10) do
        Net::SSH.start(hostname, username, ssh_options) do |ssh|
          # Capture all stderr and stdout output from a remote process
          output = ssh.exec!(ssh_cmd)
        end
      end
      # EQ56 returns unicode jibberish & looks like
      # "C\u0000a\u0000n\u0000'\u0000t\u0000 \u0000f\u0000i\u0000n\u0000d"
      convert_eq56_unicode_to_ascii(output)
    end

    def convert_eq56_unicode_to_ascii(string)
      string.gsub("\u0000",'').gsub(/\\/,'')
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
