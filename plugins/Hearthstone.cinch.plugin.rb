# -*- coding: utf-8 -*-
require 'open-uri'
require 'nokogiri'

class Hearthstone
  include Cinch::Plugin

  match /(?:card) (.*)/i 

  def initialize(*args)
    super
    @flooders = {}
    @hsHost = 'http://www.hearthpwn.com'
  end

  def execute m, q
    if not isFlooder? m.user.nick
      return nil
    end
    @flooders[m.user.nick] = Time.now
    if q.to_i == 0 and q.length > 1
      begin
        doc = Nokogiri::HTML(open("#{@hsHost}/cards?filter-name=#{URI::encode(q.gsub(/ /, '+'))}"))
        cards = doc.css(".visual-details-cell")
        return m.reply("Sorry #{m.user.nick}, there is no results :/") if cards.length == 0
        if cards.length == 1
          return showCard(m, cards.first.css("h3").children.first['href'])
        end
        m.reply("#{m.user.nick} asks for « #{q} »")
        cards.each do |card|
          m.reply(card.css("h3").children.first.content + " - " + @hsHost + card.css("h3").children.first['href'])
        end
      rescue
        m.reply("Je suis perdu dans le néant distordu :(")
      end
    else
      showCard(m, q)
    end
  end

  def showCard m, q
    begin
      doc = Nokogiri::HTML(open("#{@hsHost}/cards/#{q.gsub(/[^0-9]/, '')}"))
      cname = doc.css("h2.caption").first.content
      cdesc = doc.css(".card-info > p").first.content
      cinfo = doc.css(".infobox > ul").children
      infos = []
      cinfo.each do |info|
          infos.push(info.children.css("a").first.content) rescue next
      end
      infos.pop
      m.reply("Here is « #{cname} », #{m.user.nick}")
      m.reply(cdesc)
      m.reply(infos.join(' / '))
      m.reply("More info : http://hearthstone.gamepedia.com/#{URI::encode(cname)}")
    rescue
      m.reply("Argh, no such card :/")
    end
  end

  def isFlooder? user
    return !(@flooders.has_key?(user) && (Time.now.to_i - @flooders[user].to_i) < 3)
  end
end
