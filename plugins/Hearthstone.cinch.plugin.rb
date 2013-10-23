# -*- coding: utf-8 -*-
require 'open-uri'

class Hearthstone
  include Cinch::Plugin

  match /(?:card) (.*)/i 


  def execute m, q
    host = 'http://www.hearthpwn.com'
    begin
      q.gsub!(/ /, '+')
      doc = Nokogiri::HTML(open("#{host}/cards?filter-name=#{URI::encode(q)}"))
      cards = doc.css(".visual-details-cell")
      cards.each do |card|
        m.reply(card.css("h3").children.first.content + " - " + host + card.css("h3").children.first['href'])
      end
    rescue
      m.reply("Je suis perdu dans le néant distordu :(")
    end
  end

end
