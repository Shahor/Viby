# -*- coding: utf-8 -*-
require 'json'
require 'curb'

class Beer
  include Cinch::Plugin

  NOPE = [
    "http://www.zendette.com/wp-content/uploads/2010/04/nobeer-lg.jpg",
    "http://2.bp.blogspot.com/_X0jGKQDVKio/Sbup-pbiZaI/AAAAAAAABFE/3kkr__pFU78/s400/no_beer_sign200.jpg",
    "http://2.bp.blogspot.com/-fA84ad9QChw/TtR8UI6Om_I/AAAAAAAAB4o/hJovWkQNIUc/s1600/nobeer.jpg",
    "http://cityofbyroncity.files.wordpress.com/2012/03/no-beer.jpg"
  ]

  YAY = [
    "http://guestofaguest.com/wp-content/uploads/2008/09/oktobergurls.jpg",
    "http://blog.quickhome.com/br/wp-content/uploads/2011/07/oktoberfest_thumb2.jpg",
    "http://covermyfb.com/media/covers/16239-its-beer-time.jpg",
    "http://cdn2.mademan.com/wp-content/uploads/2012/01/beer1.jpg",
    "http://www.beer-universe.com/images/articles/357/beer_food_bazaar.jpg"
  ]

  match /(^|\s)(beer|bi(e|è)re|boire|ap(e|é)ro)/i, :use_prefix => false

  def execute m
    if Time.now.hour <= 17 and Time.now.hour >= 2
      m.reply "uh oh ... "
      m.reply NOPE.sample
    else
      m.reply YAY.sample
    end
  end
end
