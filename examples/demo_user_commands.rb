#!/usr/bin/env ruby -w

require 'yaml'
require 'equitrac_utilities/connection'

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

params = get_server_config()

# File.write("connection-sample.yml",srv_info.to_yaml)
puts "\nSRV_INFO: #{srv_info}"

eq = EquitracUtilities::Connection.new( params )

puts "\nSERVER SETTINGS:"
pp eq
