# -*- coding: utf-8 -*-
require 'open-uri'

class Reddit
    attr_accessor :alreadySeen
    attr_accessor :sauce

    include Cinch::Plugin
    
    set :help => "Usage:
!r/(subreddit)[#(type)] : pick an item from a subreddit.
!r?(search)[#(type)] : pick an item from a search.
!u/(user) : pick an item from a user' submissions
Where type could be
 - any: Any type
 - pic: only a picture
 - sub: make a subreddit search (only for search)"

    match(/(sauce|u|r)(?:(\/|\?)(.+?)(?:#(any|url|pic|sub))?)?$/, :use_prefix => true)
    def initialize(*args)
        super
        @alreadySeen = []
        @sauce = {}
        @blacklist = config['blacklist'] || []
    end

    def execute(m, category, search, board, type)
        return m.reply "Nope." if @blacklist.include? board
        return m.reply "#{m.user.nick}: http://reddit.com#{@sauce[m.user.nick]}" if category == 'sauce'
        type = (type or 'pic').to_s
        is_search = search == '?'
        is_subreddit_search = is_search && type == 'sub'
        is_board_search = category == 'r'
        board_uri = URI.escape(board)

        if is_board_search
            if is_subreddit_search
                url = "http://www.reddit.com/subreddits/search.json?q=#{board_uri}&limit=10"
            elsif is_search
                url = "http://www.reddit.com/search.json?q=#{board_uri}&limit=100"
            else
                if type == 'sub'
                    m.reply("Sorry, can't do that")
                    return
                end
                url = "http://reddit.com/r/#{board_uri}.json?limit=100"
            end

        else
            url = "http://reddit.com/user/#{board_uri}/submitted/.json?limit=100"
        end

        begin
            open_doc = open(url).read
            elements = JSON.parse(open_doc)['data']['children']
        rescue
            m.reply("Are you sure this subreddit exists?")
            return
        end


        if is_subreddit_search
            if elements.empty?
                m.reply "No subreddit for #{board} search"
            else
                result = elements.map { |el|
                    el['data']['display_name']
                }
                m.reply "Subreddits for #{board} search: #{result.join(', ')}"
            end
        else
            el = get_element(elements, type) || get_element(elements, 'any')

            if el.nil?
                if is_search
                    return m.reply "Sorry #{m.user.nick}, no result for #{board}"
                else
                    return m.reply "Sorry #{m.user.nick}, the subreddit #{board} seems empty" 
                end
            end

            @alreadySeen.push el['url']
            @sauce[m.user.nick] = el['permalink']
            if is_search
                m.reply "#{el['over_18'] ? 'NSFW - ' : ''}Random from '#{board}' search: #{el['title']} - #{el['url']} (requested by #{m.user.nick}, from board #{el['subreddit']})"
            else
                m.reply "#{el['over_18'] ? 'NSFW - ' : ''}Random from #{board}: #{el['title']} - #{el['url']} (requested by #{m.user.nick})"
            end
        end
    end

    private

    def get_element elements, type
        elements.shuffle!
        types = {
            "any" => /.*/i,
            "pic" => /(jpg|gif|png)$/i
        }
        elements.each { |el|
            url = el['data']['url']
            if url =~ types[type] && !@alreadySeen.include?(url)
                return el['data']
            end
        }
        nil
    end
end
