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
        @blacklist = config['blacklist'] || []
    end

    def execute(m, board, type)
        return m.reply "Nope." if @blacklist.include? board
        type = (type or 'pic').to_s
        begin
            open_doc = open("http://reddit.com/r/#{board}.json?limit=100").read
            elements = JSON.parse(open_doc)['data']['children'] 
        rescue 
            m.reply("Are you sure this subreddit exists?") 
            return
        end

        el = get_element(elements, type)

        if el.nil?
            if type == "any" 
                return m.reply "Sorry #{m.user.nick}, the subreddit #{board} seems empty" 
            else
                return self.execute(m, board, "any")
            end
        end

        @alreadySeen.push el['url']
        m.reply "#{el['over_18'] ? 'NSFW - ' : ''}Random from #{board}: #{el['title']} - #{el['url']} (requested by #{m.user.nick})"
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
        end while el['url'] !~ types[type] || @alreadySeen.include?(el['url']) rescue return nil

        return el
    end
end
