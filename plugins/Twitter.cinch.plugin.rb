# -*- coding: utf-8 -*-
require 'open-uri'
require 'json'

class Twitter
  include Cinch::Plugin

  match /twitter.com/, :use_prefix => false

  def execute m
    urls = m.message.split.grep URI.regexp

    if urls.any?
      urls.each do |url|
        url = URI.parse url.gsub /#!\//, '' rescue next
        next if not ['http', 'https'].include? url.scheme
        next if not url.host =~ /^(www\.)?twitter\.com/i

        begin
          doc = Nokogiri::HTML(open(url))

          if url.to_s =~ /\/photo\/\d+/i
            fullname = doc.at("span.tweet-full-name").children.first.content.strip
            content = doc.at("div.tweet-text").content.strip
          else
            fullname = doc.at("strong.fullname").children.first.content.strip
            content = doc.at("p.tweet-text").content.strip
          end

          m.reply "#{fullname}: « #{content} »"
        rescue Exception
          m.reply "I'm zorry, can't parse this twit properly..."
        end
      end
    end
  end

end
