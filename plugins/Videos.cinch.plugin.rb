#!/usr/bin/env ruby
require 'cinch'
require 'URI'
require 'open-uri'
require 'nokogiri'

class Videos
	include Cinch::Plugin

	listen_to :channel, method: :query

	def query(m)
		urls = m.message.split.grep URI.regexp

		if urls.any?
			urls.each do |url|
				begin
					return if not URI.parse(url).scheme === 'http'
				rescue
					return
				end

				infos = _query url

				m.reply "%{title}, posted by %{author}" % infos
			end
		end
	end

	private
	def _query(url)
		service = /(www\.)?(youtube|vimeo|dailymotion).*/.match URI.parse(url).host
		doc = Nokogiri::HTML(open(url))
		infos = {}

		case service
			when 'youtube'
				infos[:title] = doc.css("#eow-title").attr('title').content
				infos[:author] = doc.css(".author").first.content
			when 'vimeo'
				# to be done
			when 'dailymotion'
				# to be done
		end

		infos
	end
end
