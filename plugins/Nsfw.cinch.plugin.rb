# -*- coding: utf-8 -*-
require 'nokogiri'
require 'open-uri'



class Nsfw
    include Cinch::Plugin

    set help: "just type in '!nsfw' and I will provide"

    SOURCES = [
        "underboob",
        "boobs",
        "burstingout",
        "downblouse",
        "curvy",
        "hugeboobs",
        "randomsexiness",
        "tittydrop",
        "boobbounce",
        "NSFWFunny",
    ]
    match /nsfw$/i, :use_prefix => true

    def execute m
        open_doc = open("http://reddit.com/r/#{SOURCES.sample}" , "Cookie" => "over18=2ca6895c65d7a8e0ce05be36e92ec184e549e5fe")
        doc = Nokogiri::HTML(open_doc)

        links = doc.css('a.title').to_a
        link = links.sample.attribute('href').to_s
        while link !~ /(jpg|gif|png)$/i
            link = links.sample.attribute('href').to_s
        end

        m.reply link
    end
end