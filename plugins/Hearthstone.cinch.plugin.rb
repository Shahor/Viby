# -*- coding: utf-8 -*-
require 'open-uri'
require 'nokogiri'
require 'cgi'

class Hearthstone
  include Cinch::Plugin

  match /(?:card) (.*)/i 
  set :help => '!card query to make a search | !card ID to show a card' 

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
        doc = Nokogiri::HTML(open("#{@hsHost}/cards?filter-name=#{CGI.escape(q)}"))
        cards = doc.css(".visual-details-cell")
        return m.reply("Sorry #{m.user.nick}, there is no result :/") if cards.empty?
        return showCard(m, cards.first.css("h3").children.first['href']) if cards.length == 1
        m.reply("#{m.user.nick} asks for « #{q} »")
        cards.each do |card|
          m.reply("#{card.css("h3").children.first.content} - #{@hsHost}#{card.css("h3").children.first['href']}")
        end
      rescue
        m.reply("Mrglglglgl! (translation : I've catch an unknown error.)")
      end
    else
      showCard(m, q)
    end
  end

  def showCard m, q
    begin
      q.scan(/\d+/).each do |id|
        doc = Nokogiri::HTML(open("#{@hsHost}/cards/#{id}"))
        cname = doc.css("h2.caption").first.content
        cdesc = doc.css(".card-info > p").first.content rescue ''
        m.reply("Here is « #{cname} », #{m.user.nick}")
        m.reply("#{showStat(cname)}") 
        m.reply("« #{cdesc.squeeze(' ')} »") if not cdesc.empty?
        m.reply("More info : #{@hsHost}/cards/#{id}")
      end
    rescue
      m.reply("Argh, no such card for #{id}:/")
    end
  end

  def showStat cname
    doc = Nokogiri::HTML(open("http://hearthstone.gamepedia.com/#{URI::encode(cname)}"))
    stats = []
    doc.css("table.infobox").first.children.each do |infos|
      infos.children.each do |row|
        stats.push(row.content.gsub(/( |\n)/, '')) if row.content.strip.match(/(Cost|Attack|HP|^\d+$)/)
      end
    end
    statsStr = ''
    begin
      statsStr = statsStr + "#{stats.shift(2).join(' ')}"
      statsStr = statsStr + " | " if not stats.empty?
    end while not stats.empty?
    return statsStr
  end

  def isFlooder? user
    return !(@flooders.has_key?(user) && (Time.now.to_i - @flooders[user].to_i) < 3)
  end
end
