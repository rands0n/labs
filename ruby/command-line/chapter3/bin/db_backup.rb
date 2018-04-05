#!/usr/bin/env ruby

require 'optparse'

options = {}

option_parser = OptionParser.new do |opts|
  opts.banner = "Backup one or more MySQL databases

Usage #{File.basename($PROGRAM_NAME)} [options] database_name
  "

  # creates a switch
  opts.on('-i', '--iteration', 'Indicate that this backup is an "iteration" backup') do
    options[:iteration] = true
  end

  opts.on('-u USER', 'Database username in first.last format', /^.+\..+$/) do |user|
    options[:user] = user
  end

  opts.on('-p PASSWORD', 'Database password') do |password|
    options[:password] = password
  end

  opts.on('-h', '--help', 'Display this helper messsage') do
    puts opts
    exit
  end
end

option_parser.parse!
if ARGV.empty?
  puts "Error: you must supply a database_name"
  puts
  puts option_parser.help
else
  database_name = ARGV[0]
end
# puts option_parser.inspect
