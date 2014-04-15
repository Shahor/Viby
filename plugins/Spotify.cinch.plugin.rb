# -*- coding: utf-8 -*-
# Inspired by https://github.com/netfeed/cinch-spotify

require 'json'
require 'open-uri'

class Spotify
  include Cinch::Plugin

  match /(spotify:(album|track|artist):[a-zA-Z0-9]+)/, :use_prefix => false
  match /(https?:\/\/(open|play).spotify.com\/(album|track|artist)\/[a-zA-Z0-9]+)/, :use_prefix => false

  def execute m, uri, type
    data = JSON.parse(open("http://ws.spotify.com/lookup/1/.json?uri=#{uri}").read)

    msg = case type
          when /artist/
            "Artist: #{data['artist']['name']}"
          when /album/
            "Album: #{data['album']['name']} by #{data['album']['artist']}"
          when /track/
            "Track: #{data['track']['name']} by #{data['track']['artists'].first['name']} (#{data['track']['album']['name']})"
          else
            "Something went wrong"
          end

    m.reply "Spotify: #{msg}"
  end

end
