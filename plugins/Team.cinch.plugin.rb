# -*- coding: utf-8 -*-

class Team
  include Cinch::Plugin

  match /(?:team|quake|q3|ctf) ((?:[\w\-]+\s*)+)/i

  set :help => "!team or !quake or !q3 or !ctf followed by the space separated player list"

  def execute m, players
    players = players.strip.gsub(/\s+/, ' ').split(' ')
    blue = players.sample(players.size / 2)
    red = players - blue
    m.reply "BLUE: #{blue.join(" ")}"
    m.reply "RED: #{red.join(" ")}"
  end

end
