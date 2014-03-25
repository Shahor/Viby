# -*- coding: utf-8 -*-
require 'json'
require 'open-uri'

class FiveHundredPx
  include Cinch::Plugin

  API_URL = 'https://api.500px.com/v1/photos'
  match /500(?:\s+([\w\s]+))?/i, :use_prefix => true

  set :help => "!500 [category] (see https://github.com/500px/api-documentation/blob/master/basics/formats_and_terms.md#categories for infos)"

  def execute m, match
    p match
    return if config['consumer_key'].nil?

    query = "#{API_URL}?image_size=4&rpp=50&consumer_key=#{ config['consumer_key'] }"
    query += "&only=#{ URI::encode(match) }" unless match.nil?
    document = open query
    photos = JSON.parse(document.read)

    photo = photos['photos'].sample
    m.reply "'#{ photo['name'] }' by #{ photo['user']['username'] }"
    m.reply photo['image_url']
  end
end