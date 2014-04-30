# -*- coding: utf-8 -*-
require 'open-uri'
require 'nokogiri'

class Weekend
  include Cinch::Plugin

  set :help => '!weekend | Try it.'

  match /weekend$/i

  def execute m
    begin
      weekend = Nokogiri::HTML(open("http://estcequecestbientotleweekend.fr"))
      weekend.search("//p[@class='msg']").each{ |e| m.reply e.content.strip }
    rescue 
      m.reply("J'ai planté :(") 
      return
    end
  end

end
