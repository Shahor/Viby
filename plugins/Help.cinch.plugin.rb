# -*- coding: utf-8 -*-

class Help
  include Cinch::Plugin

  match /help$/i, :use_prefix => true

  def execute m
    helpful = []
    m.bot.plugins.each { |e| 
      helpful << e if e.class.help != nil
    }
    m.reply "Hey! You can ask for help on any of the following Plugins by typing '!help plugin_name' : #{helpful.map{ |e| e.class.name.downcase  }.join(', ')}"
  end

end
