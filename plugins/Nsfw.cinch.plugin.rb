# -*- coding: utf-8 -*-
require 'nokogiri'
require 'open-uri'

class Nsfw
    attr_accessor :alreadySeen, :lastFlush
    include Cinch::Plugin

    set :help => "just type in '!nsfw' and I will provide"

    HIGHLY_NSFW = [
        "underboob",
        "burstingout",
        "downblouse",
        "curvy",
        "tittydrop",
        "nsfw"
    ]

    MIDDLY_NSFW = [
        "randomsexiness",
        "boobies",
        "boobs",
        "gonewildcurvy",
        "LegalTeens",
        "Hotchickswithtattoos",
        "SexyButNotPorn",
        "nude",
        "Unashamed",
        "GirlsinTUBEsocks"
    ]

    match /nsfw$/i, :use_prefix => true
    def initialize(*args)
        super
        if not config.include? "reddit_cookie"
            raise "This plugin won't run unless you specify a cookie value for reddit [look for the over18 cookie in a nsfw board]"
        end

        @lastFlush = Time.now.to_i
        @alreadySeen = []
        @lastSeenPerUser = {}
    end

    def execute m
        if not userCan? m.user.nick
            m.reply "Oh #{m.user.nick}, you already had your treat today !"
            return nil
        end

        board = if Time.now.hour >= 18
            HIGHLY_NSFW.sample
        else
            MIDDLY_NSFW.sample
        end

        open_doc = open("http://reddit.com/r/#{board}" , "Cookie" => "over18=#{config['reddit_cookie']}")
        links = Nokogiri::HTML(open_doc).css('a.title').to_a

        begin
            link = getImageFromLinks links
        end while @alreadySeen.include? link

        flushCashIfNeeded
        @lastSeenPerUser[m.user.nick] = Time.now
        @alreadySeen.push link
        m.reply link
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

    def getImageFromLinks links
        link = links.sample.attribute('href').to_s
        while link !~ /(jpg|gif|png)$/i
            link = links.sample.attribute('href').to_s
        end

        return link
    end
end