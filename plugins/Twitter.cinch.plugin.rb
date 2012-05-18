#!/usr/bin/env ruby
require 'cinch'
require 'open-uri'
require 'nokogiri'
require 'URI'

class Older
	include Cinch::Plugin

    match /twitter.com/, :use_prefix => false

    def execute m
    	urls = m.message.split.grep URI.regexp
    	if urls.any?
    		urls.each do |url|
    			url = URI.parse url.gsub /#!\//, ''
    			return if not url.scheme =~ /http/
    			return if not url.to_s =~ /twitter.com\//

    			twit = Nokogiri::HTML(open url.to_s)
    			author = twit.css('meta[name=page-user-screen_name]').attribute('content').value
    			content = twit.css('meta[name=description]').attribute('content').value
    			m.reply "#{author} (https://twitter.com/#{author}) said : "
    			m.reply content
    		end
    	end
    end
end
