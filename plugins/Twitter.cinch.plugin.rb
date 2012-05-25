#!/usr/bin/env ruby
require 'cinch'
require 'open-uri'
require 'URI'
require 'json'
require 'curb'

class Twitter
	include Cinch::Plugin

    match /twitter.com/, :use_prefix => false

    def execute m
    	urls = m.message.split.grep URI.regexp
    	if urls.any?
    		urls.each do |url|
    			url = URI.parse url.gsub /#!\//, ''
    			return if not url.scheme =~ /http/
    			return if not url.to_s =~ /twitter.com\//

                begin

                    statusId = url.to_s.match(/status\/(\d*)/)[1]

                    data = JSON.parse(Curl::Easy.perform("https://api.twitter.com/1/statuses/show.json?id=#{statusId}").body_str)

                    author = data['user']['screen_name']
        			fullname = data['user']['name']
        			content = data['text']

        			m.reply "#{fullname} (https://twitter.com/#{author}) said : "
        			m.reply content

                    if not data['retweeted_status'].nil?
                        originalUser = data['retweeted_status']['user']['screen_name']
                        originalTwit = "https://twitter.com/#{originalUser}/status/#{data['retweeted_status']['id_str']}"
                        m.reply "This is a retweet from #{originalUser} (#{originalTwit})"
                    end
                rescue
                   m.reply "I'm zorry, can't parse this twit properly..."
                end
    		end
    	end
    end
end
