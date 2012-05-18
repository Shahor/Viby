#!/usr/bin/env ruby
require 'cinch'
require 'pathname'

pluginsToLoad = []

Dir['plugins/*.cinch.plugin.rb'].each do |plugin|
	require File.dirname(__FILE__) + "/#{plugin}"

	pluginName = Pathname.new(plugin).basename.to_s.gsub /\.cinch\.plugin\.rb/, ''
	pluginName[0] = pluginName[0].upcase

	begin
		pluginConst = Kernel.const_get pluginName
		pluginsToLoad << pluginConst if pluginConst
	rescue
		puts "Error trying to load #{plugin}. Tried to load #{pluginName} "
	end
end

bot = Cinch::Bot.new do
	configure do |c|
		c.nick = "__VALUE__"
		c.server = "__VALUE__"
		c.channels = ["__VALUE__"]
		c.password = "__VALUE__"
		c.ssl = Cinch::Configuration::SSL.new use: true
		c.plugins.plugins = pluginsToLoad
	end
end

bot.start
