# -*- coding: utf-8 -*-

class ParContre
  include Cinch::Plugin

  match /(par contre|en revanche)/i, :use_prefix => false

  set :help => "BITCH I WILL TEACH YOU"

  def execute m, message
    m.reply message.downcase == "par contre" ?  "en revanche*" : "♥"
  end

end
