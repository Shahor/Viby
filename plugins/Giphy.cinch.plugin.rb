# -*- coding: utf-8 -*-
require 'open-uri'
require 'pp'

class Giphy
  include Cinch::Plugin

  match /(?:gif) (.*)/i

  set :help => '!gif query'

  def initialize(*args)
    super
    @apikey = config['apikey']
  end

  def execute m, q
    begin
      repasa = open("http://api.giphy.com/v1/gifs/search?q=#{URI::encode(q)}&api_key=#{@apikey}&limit=100&offset=0").read
      result = JSON.parse(repasa)
      return m.reply "Pas de résultats, pas de gif. Pas de gif, pas de gif" if result['pagination']['total_count'] == "0"
      res = result['data'].sample
      m.reply "#{res['images']['original']['url']}  (from #{res['source']})"
    rescue 
      m.reply("Je planta :(") 
      return
    end
  end

end
