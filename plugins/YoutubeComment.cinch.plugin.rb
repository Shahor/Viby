# -*- coding: utf-8 -*-
require 'nokogiri'
require 'open-uri'

class YoutubeComment
  include Cinch::Plugin

  listen_to :channel, method: :query

  def initialize(*args)
    super
    config.each do |index, item|
      if item['match'].empty?        then raise "Error : match regex is empty" end
      if item['ids'].empty?          then raise "Error : At least one video id should be specified" end
      if item['kw_required'].empty?  then raise "Error : require seems empty. Maybe : /.*/ ?" end
      if item['kw_forbidden'].empty? then raise "Error : forbid seems empty.  Maybe : /$^/ ?" end
    end
  end

  def query m
    config.each do |index, item|
      if eval(item['match']).match m.message
        try = 0
        begin
          try += 1
          doc = open("https://gdata.youtube.com/feeds/api/videos/#{item['ids'].sample}/comments?max-results=50")
          comments = Nokogiri::HTML(doc).search('content').to_a
          candidates = comments.select {|e| (eval(item['kw_required']).match(e) && !eval(item['kw_forbidden']).match(e)) }
          comment = candidates.sample
        end while (try < item['ids'].count && comment.nil?)
        if !comment.nil? then m.reply comment.text else m.reply "I found no funny comments to share :-( " end
      end  
    end
  end
end