#!/usr/bin/env ruby -w

require 'yaml'
require 'equitrac_utilities/connection'

params = Action.get_server_config()

# File.write("connection-sample.yml",srv_info.to_yaml)
puts "\nSRV_INFO: #{srv_info}"

eq = EquitracUtilities::Connection.new( params )

puts "\nSERVER SETTINGS:"
pp eq

# read users YAML
users = Actions.get_users_info()

exit unless Actions.continue?(users)
puts "creating eq56 accounts ..."

Actions.create_users(users)

module Actions
  def get_srv_config
    srv_file   = nil
    srv_file   = 'connection-sample.yml' if File.file?('connection-sample.yml')
    srv_file   = 'connection.yml'        if File.file?('connection.yml') # real
    #
    yml_info   = {hostname: 'equitrac.example.com', # remote server hostname
                  username: 'remote',               # remote login username
                  eq_service: 'eq56',               # equitrac SERVICE name
                }
    begin
      yml_info = YAML.load_file(srv_file)
    rescue ArgumentError => e
      puts "YAML Error: #{e.message}"
    end                                    unless srv_file.nil?
    yml_info = YAML.load_file(srv_file) unless srv_file.nil?
    return defaults.merge( yml_info )
  end
  module_function :get_srv_config

  def get_users_info
    users_file ||= nil
    users_file = 'users-sample.yml' if File.file?('users-sample.yml')
    users_file = 'users.yml'        if File.file?('users.yml') # real
    users = [
              { primary_pin: 12345,
                user_id: "username1",
                email: "username1@examle.com",
                user_name: "FirstName1 LastName1",
                dept_name: 'employee',
              }
            ]
    begin
      users  = YAML.load( File.open(users_file) )
    rescue ArgumentError => e
      puts "YAML Error: #{e.message}"
    end                         unless users_file.nil?
    # File.write("users-sample.yml",users.to_yaml)
    return users
  end
  module_function :get_users_info

  def continue?(users)
    puts "\nUSERS:"
    pp users

    # add is this what you expect?
    puts "Review the user data \nEnter 'Y' to create eq56 accounts"
    answer = gets.chomp.downcase

    return true if answer.eql? 'y'

    puts "aborting account creation"
    false
  end
  module_function :continue?

  def create_users( users )
    puts "\nEQ56 Commands:"
    users.each do |person|
      person[:init_bal] = 50.0
      cmd = Equitrac::Utilities::User.add( person )
      puts cmd
      puts server.execute(cmd)
    end                       unless users.nil?
    puts "OOPS no users!"         if users.nil?
  end
  module_function :create_users
end
