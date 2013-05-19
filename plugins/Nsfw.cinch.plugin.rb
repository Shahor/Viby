# -*- coding: utf-8 -*-
require 'open-uri'

class Nsfw
    attr_accessor :alreadySeen, :lastFlush
    include Cinch::Plugin

    set :help => "just type in '!nsfw' and I will provide"

    match(/nsfw$/i, :use_prefix => true)
    def initialize(*args)
        super

        # Restriction
        @users = {
          :mildly_nsfw => {},
          :very_nsfw => {}
        }

        # Prevent empty conf
        config["very_nsfw"] = {"nsfw" => nil} if config["very_nsfw"].nil?
        config["mildly_nsfw"] = {"gentlemanboners" => nil} if config["mildly_nsfw"].nil?

        [:very_nsfw, :mildly_nsfw].each do |type|
          config[type.to_s].each do |name , users|
            if users
              config[type.to_s].delete name
              users.each do |user|
                puts user
                @users[type][user].push(name) rescue @users[type][user] = [name]
              end
            end
          end
        end

        @very_nsfw = config['very_nsfw'].keys
        @mildly_nsfw = config['mildly_nsfw'].keys

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
            if @users[:very_nsfw][m.user.nick]
              @users[:very_nsfw][m.user.nick].sample
            else
              @very_nsfw.sample
            end
        else
          if @users[:mildly_nsfw][m.user.nick]
            @users[:mildly_nsfw][m.user.nick].sample
          else
            @mildly_nsfw.sample
          end
        end

        open_doc = open("http://reddit.com/r/#{board}.json").read
        elements = JSON.parse(open_doc)['data']['children']

        begin
            link, title = get_data_from_json elements
        end while @alreadySeen.include? link

        flushCashIfNeeded
        @lastSeenPerUser[m.user.nick] = Time.now
        @alreadySeen.push link
        m.reply "NSFW! #{title} : #{link} (for #{m.user.nick}, taken from #{board})"
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