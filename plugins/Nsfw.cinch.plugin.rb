# -*- coding: utf-8 -*-
require 'open-uri'

class Nsfw
    attr_accessor :alreadySeen, :lastFlush
    include Cinch::Plugin

    set :help => "just type in '!nsfw' and I will provide"

    match(/nsfw$/i, :use_prefix => true)
    def initialize(*args)
        super

        @very_nsfw = config['very_nsfw']
        @mildly_nsfw = config['mildly_nsfw']

        @lastFlush = Time.now.to_i
        @alreadySeen = []
        @lastSeenPerUser = {}
    end

    def execute m
        if not userCan? m.user.nick
            m.reply "Oh #{m.user.nick}, you already had your treat today !"
            return nil
        end

        board = if Time.now.hour >= 18 || Time.now.hour <= 7
            @very_nsfw.sample
        else
            @mildly_nsfw.sample
        end

        open_doc = open("http://reddit.com/r/#{board}.json").read
        elements = JSON.parse(open_doc)['data']['children']

        begin
            link, title = get_data_from_json elements
        end while @alreadySeen.include? link

        flushCashIfNeeded
        @lastSeenPerUser[m.user.nick] = Time.now
        @alreadySeen.push link
        m.reply "NSFW ! #{title} : #{link}"
    end

    private

    def userCan? user
        return !(@lastSeenPerUser.has_key?(user) && @lastSeenPerUser[user].day == Time.now.day)
    end

    def flushCashIfNeeded
        now = Time.now.to_i

        if (now - @lastFlush) > 604800 # more than 7 days old
            @lastFlush = now
            @alreadySeen.clear
        end
    end

    def get_data_from_json elements
        begin
            el = elements.sample['data']
            link = el['url'].to_s
            title = el['title'].to_s
        end while link !~ /(jpg|gif|png)$/i

        return link, title
    end
end