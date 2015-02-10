# -*- coding: utf-8 -*-

class Magic
  include Cinch::Plugin

  match /magic|magique/i, :use_prefix => false

  set :help => "MAAAAGIC!"

  def execute m
    m.reply "http://i.imgur.com/64oU9ku.gif"
  end

end