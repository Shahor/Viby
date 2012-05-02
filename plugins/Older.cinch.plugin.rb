#!/usr/bin/env ruby
require 'cinch'
require 'open-uri'
require 'URI'

class Older
	include Cinch::Plugin

	History = 100
	Pictures = [
		"http://www.monaco-munich.de/images/galerie/74_dodge_monaco_blues_brothers_setpic.jpg",
		"http://f.cl.ly/items/1X2L2f0L1j0Q1M2v1N0H/b6A9M.gif",
		"http://play-auto.net/wp-content/uploads/2009/12/old-police-car.GIF",
		"http://4.bp.blogspot.com/_8gyAih3p8fY/TVGzMTLbf8I/AAAAAAAABho/Jmr8x1ZD5AI/s1600/uncle-sam.jpg",
		"http://foodfamilyfinds.com/wp-content/uploads/2010/05/illinois-police-memorial-old-police-car.jpg",
		"http://icanhascheezburger.files.wordpress.com/2009/02/funny-pictures-your-cat-does-not-care.jpg",
		"http://spoonfulpb.files.wordpress.com/2011/09/interested_lol_cat.jpg",
	]
	Sentences = [
		"This link is so OLD ... (posted by %{author} at %{date})",
		"You've been olded by %{author} [posted at %{date}]",
		"Bro, you're so OLD ! %{author} posted it at %{date}",
		"Boooooyaaaaaaaaaaa ! %{author} just made you a swag older (posted on %{date})"
	]
	attr_accessor :linksToOld

	listen_to :channel, method: :considerOlding

	def initialize(*args)
		super
		@linksToOld = {}
	end

	def considerOlding(m)
		urls = m.message.split.grep URI.regexp

		if urls.any?
			urls.each do |url|
				if _isOld? url
					m.reply Pictures.sample if _addPicture?
					m.reply Sentences.sample % @linksToOld[url]
				else
					_newLink url, {
						author: m.user.nick,
						date: Time.now.strftime("%Y-%m-%d %H:%M:%S"),
					}
				end
			end
		end
	end

	private

	def _addPicture?
		rand <= 0.33
	end

	def _newLink(link, linkDetails)
		@linksToOld[link] = linkDetails
		_resizeStack
	end

	def _resizeStack
		if @linksToOld.length > History
			begin
				@linksToOld.shift
			end unless @linksToOld.length <= History
		end
	end

	def _isOld?(link)
		!@linksToOld[link].nil?
	end
end
