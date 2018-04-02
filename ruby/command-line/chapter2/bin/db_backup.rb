#!/usr/bin/env ruby

require 'optparse'

options = {}

option_parser = OptionParser.new do |opts|
  # creates a switch
  opts.on('i', '--iteration') do
    options[:iteration] = true
  end

  opts.on('-u USER', /^.+\..+$/) do |user|
    options[:user] = user
  end

  opts.on('-p PASSWORD') do |password|
    options[:password] = password
  end

  opts.on('h', '--help') do
    puts opts
    exit
  end
end

option_parser.parse!
# puts option_parser.inspect