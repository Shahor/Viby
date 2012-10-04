#!/usr/bin/env ruby
require 'bundler/setup'
require 'cinch'
require 'yaml'

ROOT = File.dirname(__FILE__)

plugins = []

Dir[File.join(ROOT, 'plugins', '*.cinch.plugin.rb')].each do |plugin|
  begin
    require plugin
    name = File.basename(plugin).split('.').first
    klass = Kernel.const_get name
    plugins << klass
  rescue NameError
    puts "Error trying to load #{plugin.inspect}. #{name} not found."
  rescue
    puts "Error trying to load #{plugin.inspect}. Tried to load #{name}."
  end
end

configFile = File.join(ROOT, 'config.yml')
if File.exists? configFile
  config = YAML.load_file(configFile)

  bot = Cinch::Bot.new do
    configure do |c|
      c.nick = config['nick'] || 'viby'
      c.server = config['server'] || 'localhost'
      c.channels = config['channels'] || ['#viby']
      c.password = config['password']
      c.ssl = Cinch::Configuration::SSL.new use: true if config['ssl']
      c.plugins.plugins = plugins
    end
  end

  bot.start
else
  puts "Config file not found"
end
