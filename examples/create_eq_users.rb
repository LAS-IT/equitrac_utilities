#!/usr/bin/env ruby -w

require 'yaml'
require 'equitrac_utilities'

yml_info
begin
  yml_info = YAML.load_file( File.open('connection.yml') )
rescue Errno::ENOENT, LoadError, Psych::SyntaxError, YAML::Error
  yml_info   = {hostname: 'equitrac.example.com', # remote server hostname
                username: 'remote',               # remote login username
                eq_service: 'eq56',               # equitrac SERVICE name
              }
ensure
  puts "\nSRV_INFO: #{params}"
  eq = EquitracUtilities::Connection.new( params )
  puts "\nSERVER SETTINGS:"
  pp eq
end

def get_users_info
  users_file ||= nil
  users_file = 'users-sample.yml' if File.file?('users-sample.yml')
  users_file = 'users.yml'        if File.file?('users.yml') # real

users = []
begin
  users  = YAML.load( File.open('users.yml') )
rescue ArgumentError => e
  users  = [{ primary_pin: 12345,
              user_id: "username1",
              email: "username1@examle.com",
              user_name: "FirstName1 LastName1",
              dept_name: 'employee',
          }]
end
puts "\nUSERS:"
pp users

# add is this what you expect?
puts "Review the user data \nEnter 'Y' to create eq56 accounts"
answer = gets.chomp.downcase

unless answer.eql? 'y'
  puts "aborting account creation"
  exit(0)
end

if users.nil?
  puts "OOPS no users!"
  exit(0)
end

puts "\nEQ56 Commands:"
Array(users).each do |person|
  # Dry Run commands
  # pp eq.send(:user_add, person )
  # Run Commands
  pp eq.run(command: :user_add, attributes: person )
end
