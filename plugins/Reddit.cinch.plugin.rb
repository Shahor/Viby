# -*- coding: utf-8 -*-
require 'open-uri'

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
            open_doc = open("http://reddit.com/r/#{board}.json").read
            elements = JSON.parse(open_doc)['data']['children'] 
        rescue 
            m.reply("Are you sure this subreddit exists?") 
            return
        end

        begin
            link, title = get_data_from_json(elements, type)
        end while @alreadySeen.include? link

        @alreadySeen.push link
        m.reply "Random from #{board}: #{title} - #{link}"
    end

    private

    def get_data_from_json elements, type
        types = {
            "any" => /.*/i,
            "pic" => /(jpg|gif|png)$/i
        }
        begin
            el = elements.sample['data']
            link = el['url'].to_s
            title = el['title'].to_s
        end while link !~ types[type]

        return link, title
    end
end