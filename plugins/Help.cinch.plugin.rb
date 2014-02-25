# -*- coding: utf-8 -*-

class Help
  include Cinch::Plugin

  match /help$/i, :use_prefix => true

  def execute m
    m.reply "Hey! You can ask for help on any of the following Plugins by typing '!help plugin_name' : #{m.bot.plugins.map{ |e| e.class.name.downcase  }.join(', ')}"
  end

end
