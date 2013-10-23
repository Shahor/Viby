# -*- coding: utf-8 -*-
require 'open-uri'

class Hearthstone
  include Cinch::Plugin

  match /(http:\/\/(www\.)?hearthhead.com\/card=[0-9]+)/, :use_prefix => false

  def execute m
    urls = m.message.split.grep URI.regexp

    if urls.any?
      urls.each do |url|
        url = URI.parse url
        next if not url.host =~ /^(www\.)?hearthhead\.com/

        begin
          doc = Nokogiri::HTML(open(url))

          atq = doc.css("span.hearthstone-attack").first
          pv = doc.css("span.hearthstone-health").first
          cost = doc.css("span.hearthstone-cost").first

          name = doc.css("meta[property='og:title']").first['content']
          desc = doc.css("meta[property='og:description']").first['content']

          m.reply "(#{cost}) #{name} [#{atq}/#{pv}] : #{desc}"
        rescue Exception
          m.reply "Sorry, some murlocs are in your url :/"
        end
      end
    end
  end

end
