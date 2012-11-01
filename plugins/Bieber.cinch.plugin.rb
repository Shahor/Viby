# -*- coding: utf-8 -*-
require 'cinch'
require 'nokogiri'
require 'open-uri'

class Bieber
  include Cinch::Plugin

  VIDEOS    = ['kffacxfA7G4', '4GuqB1BQVr4', 'R4em3LKQCAQ', 'Ys7-6_t7OEQ', 'kffacxfA7G4', 'D5BFag1iGvU', 'LUjn3RpkcKY', 'nEUuRXEjxnE']
  REGEX_INC = /(love|gay)/i
  REGEX_EXC = /(watch\?|subscribe|check|channel|spam|please)/i

  match /(^|\s)(Bieber)/i, :use_prefix => false

  def execute m
	  try = 0
	 	begin
	 		try = try + 1
	 		open_doc = open("https://gdata.youtube.com/feeds/api/videos/#{VIDEOS.sample}/comments?max-results=50")
	 		comments = Nokogiri::HTML(open_doc).search('content').to_a
	 		candidates = comments.select {|e| (REGEX_INC.match(e) && !REGEX_EXC.match(e)) }
	 		comment = candidates.sample
	 	end while (try < VIDEOS.count && comment == nil)
	 	m.reply comment != nil ? comment.text : "I found no funny comments to share :-( "
	end
end