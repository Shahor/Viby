#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
# Copyright (c) 2010 Victor Bergöö
# This program is made available under the terms of the MIT License.
# https://github.com/netfeed/cinch-spotify

require 'cinch'
require 'json'
require 'curb'

class Spotify
    include Cinch::Plugin

    match /(spotify:(album|track|artist):[a-zA-Z0-9]+)/, :use_prefix => false
    match /(http:\/\/open.spotify.com\/(album|track|artist)\/[a-zA-Z0-9]+)/, :use_prefix => false

    def execute m, uri, type
        msg = case type
        when /artist/ then _artist uri
        when /album/ then _album uri
        when /track/ then _track uri
        else 'something went wrong'
        end

        m.reply("Spotify: #{msg}")
    end

    def _artist uri
        json = _lookup uri
        name = json['artist']['name']
        "Artist: #{name}"
    end

    def _album uri
        json = _lookup uri
        artist = json['album']['artist']
        album = json['album']['name']
        "Album: #{album} by #{artist}"
    end

    def _track uri
        json = _lookup uri
        artist = json['track']['artists'].first['name']
        album = json['track']['album']['name']
        track = json['track']['name']
        "Track: #{track} by #{artist} (#{album})"
    end

    def _lookup spotify_uri
        content = Curl::Easy.perform("http://ws.spotify.com/lookup/1/.json?uri=#{spotify_uri}").body_str
        JSON.parse(content)
    end
end
