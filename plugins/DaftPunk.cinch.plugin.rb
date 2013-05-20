# -*- coding: utf-8 -*-
require 'open-uri'

class DaftPunk
  include Cinch::Plugin

  match /(?:daftpunk|google) (.*)/i

  set :help => '!daftpunk or !google query | Link for the lazy.'

  def initialize(*args)
    super
    @apikey = config['apikey']
    @cx = config['cx']
  end

  def execute m, q
    begin
      repasa = open("https://www.googleapis.com/customsearch/v1?key=#{@apikey}&q=#{URI::encode(q)}&alt=json&cx=#{@cx}").read
      result = JSON.parse(repasa)
      return m.reply "Pas de résultats" if result['searchInformation']['totalResults'] == "0"
      res = result['items'].first
      m.reply "#{res['link']}  (#{res['title']})"
    rescue 
      m.reply("J'ai planté :(") 
      return
    end
  end

end
