# -*- coding: utf-8 -*-
require 'lastfm'

class Lastfmnow
  include Cinch::Plugin

  match /(?:nowplaying) (.*)/i

  set :help => '!nowplaying lastfmpseudo'

  def initialize(*args)
    super
    @apikey = config['apikey']
    @lastfm = Lastfm.new(@apikey, "osef")

  end

  def execute m, username

    begin

      response = @lastfm.user.get_recent_tracks(username)

      if response.length == 0
        raise "Hum, this user hasn't listened music since a while !"
      end

      message = "Dernière chanson écoutée par " + username + " : "
      m.reply message + response[0]["artist"]["content"] + " - " + response[0]["name"]

    rescue Exception => e

      m.reply e.message

    end

  end

end



