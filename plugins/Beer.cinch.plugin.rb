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

  match /\"(.*)\".(to_beer|to_b)/i, :use_prefix => false, :method => :brewerydb
  match /(^|\s)(beer|bi(e|è)re|boire|ap(e|é)ro)/i, :use_prefix => false, :method => :timer

  def timer m
    if Time.now.hour <= 17 and Time.now.hour >= 2
      m.reply "uh oh ... "
      m.reply NOPE.sample
    else
      m.reply YAY.sample
    end
  end

  def brewerydb m, beer_name

    return unless !config['apikey'].nil?

    base_url = 'http://api.brewerydb.com/v2/search'
    query    = URI::encode(beer_name)
    document = open("#{base_url}?q=#{query}&key=#{config['apikey']}&type=beer").read
    beers    = JSON.parse(document)

    if beers['data'].nil?
      m.reply "Je connais pas la #{beer_name}."
      return;
    end

    if beers['data'][0]['name'].downcase == beer_name.downcase \
       or beers['data'].count() < 2

      if beers['data'][0]['description'].nil?
        m.reply "Je connais seulement de nom la #{beer_name}."
        return
      else
        m.reply beers['data'][0]['description'].capitalize
        return
      end

    end

    if beers['data'].count > 1
      m.reply "#{beer_name.capitalize} ? Tu veux dire la :"
      beers['data'][0..3].each do |beer|
        m.reply beer['name'] + ' ?'
      end
    end

  end

end