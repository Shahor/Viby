# -*- coding: utf-8 -*-
require 'open-uri'
require 'pp'

class Reddit
    attr_accessor :alreadySeen

    include Cinch::Plugin
    
    set :help => "Usage: !r/(subreddit)[#(type)]\nWhere type could be\n - any: Any type\n - pic: only a picture\n Type is default to pic."

    match(/r\/(\w+)(?:#(any|url|pic))?$/, :use_prefix => true)
    def initialize(*args)
        super
        @alreadySeen = []
    end

    def execute(m, board, type)
        type = (type or 'pic').to_s
        begin
            open_doc = open("http://reddit.com/r/#{board}.json?limit=100").read
            elements = JSON.parse(open_doc)['data']['children'] 
        rescue 
            m.reply("Are you sure this subreddit exists?") 
            return
        end

        begin
            el = get_element(elements, type)
        end while @alreadySeen.include? el['url'] rescue 

        return m.reply "Sorry, nothing for you :( try typing !r/#{board}#any ?" if el.nil?

        @alreadySeen.push el['url']
        m.reply "#{el['over_18'] ? 'NSFW - ' : ''}Random from #{board}: #{el['title']} - #{el['url']}"
    end

    private

    def get_element elements, type
        elements.shuffle!
        types = {
            "any" => /.*/i,
            "pic" => /(jpg|gif|png)$/i
        }
        begin
            el = elements.pop['data']
        end while el['url'] !~ types[type] rescue return nil

        return el
    end
end