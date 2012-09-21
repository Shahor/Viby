#!/usr/bin/env ruby
require 'cinch'
require 'open-uri'
require 'URI'
require 'json'
require 'curb'
require 'twitter'

class TwitterParser
	include Cinch::Plugin

    match /twitter.com/, :use_prefix => false

    def initialize(*args)
        super

        _initTwitterConfig
    end

    def execute m
    	urls = m.message.split.grep URI.regexp
    	if urls.any?
    		urls.each do |url|
    			url = URI.parse url.gsub /#!\//, ''
    			return if not url.scheme =~ /http/
    			return if not url.to_s =~ /twitter.com\//

                begin
                    statusId = url.to_s.match(/status(es)?\/(\d*)/)[2]

                    data = Twitter.status statusId
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
                rescue Exception => e
                    p e
                    m.reply "I'm zorry, can't parse this twit properly..."
                end
            end
        end
    end

    private

    def _initTwitterConfig
        configFile = "#{Dir.pwd}/pluginsConfig/TwitterParser.config.json"

        if not File.exists? configFile
            raise "This plugin needs its config file, please create and fill it"
        end

        appConfig = JSON.parse File.read(configFile)

        ["consumer_key", "consumer_secret", "oauth_token", "oauth_token_secret"].each do |key|
            raise "missing key #{key} in plugin config" if not appConfig.has_key? key
            raise "#{key} must not be empty !!" if appConfig[key].length === 0
        end

        Twitter.configure do |config|
            config.consumer_key = appConfig['consumer_key']
            config.consumer_secret = appConfig['consumer_secret']
            config.oauth_token = appConfig['oauth_token']
            config.oauth_token_secret = appConfig['oauth_token_secret']
        end
    end
end
