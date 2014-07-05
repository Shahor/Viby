# -*- coding: utf-8 -*-

class Coucou
  include Cinch::Plugin

  match /coucou$/i, :use_prefix => false

  TEUB = [
    "http://www.thenewage.co.za/classifieds/onlineimages/TNA101672-4242014.jpg",
  ]

  def execute m
    m.reply "Tu veux voir ma bite ? #{TEUB.sample} (for #{m.user.nick})"
  end

end
