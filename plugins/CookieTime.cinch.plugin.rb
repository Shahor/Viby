#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require 'cinch'
require 'json'
require 'curb'

class CookieTime
    include Cinch::Plugin

    Images = [
    	"http://26.media.tumblr.com/tumblr_lhfu79te151qhcviko1_500.jpg",
    	"http://24.media.tumblr.com/tumblr_lhfsbaGHpC1qhcviko1_500.jpg",
    	"http://25.media.tumblr.com/tumblr_lhfrjnWKqu1qhcviko1_400.jpg",
    	"http://27.media.tumblr.com/tumblr_lhfpu5l3ZO1qhcviko1_500.png",
    	"http://28.media.tumblr.com/tumblr_lhfnblLRpR1qhcviko1_400.jpg",
    	"http://28.media.tumblr.com/tumblr_lhfn3bdqzy1qhcviko1_400.jpg"
    ]

    match /gouté|gouter|goutay/i, :use_prefix => false

    def execute m
    	if not Time.now.hour === 16
    		m.reply "uh oh ... "
    		m.reply Images.sample
    	end
    end
end