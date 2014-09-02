# -*- coding: utf-8 -*-
require 'lastfm'

class Lastfm
  include Cinch::Plugin

  match /(?:nowplaying) (\w)/i

  set :help => "!nowplaying lastfmpseudo"

  def initialize(*args)
    super
    Wolfram.appid = config['appid']
  end

  def execute m, username
    lastfm = Lastfm.new( config['apikey'], api_secret)
    token = lastfm.auth.get_token

    response = lastfm.user.getInfo(username)

    m.reply(response.username)


  end

end