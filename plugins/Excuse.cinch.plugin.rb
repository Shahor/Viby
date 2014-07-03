# -*- coding: utf-8 -*-
require 'open-uri'
require 'nokogiri'

class Excuse
  include Cinch::Plugin

  match /excuse/, :use_prefix => true

  def execute m
    url = "http://www.programmerexcuses.com"

    begin
      doc = Nokogiri::HTML(open url)
      m.reply doc.at('a').content
    rescue
      m.reply "Meh ¯\\_(ツ)_/¯"
    end
  end

end
