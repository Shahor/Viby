#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require 'cinch'
require 'json'
require 'curb'

class CookieTime
    include Cinch::Plugin

    Nope = [
    	"http://26.media.tumblr.com/tumblr_lhfu79te151qhcviko1_500.jpg",
    	"http://24.media.tumblr.com/tumblr_lhfsbaGHpC1qhcviko1_500.jpg",
    	"http://25.media.tumblr.com/tumblr_lhfrjnWKqu1qhcviko1_400.jpg",
    	"http://27.media.tumblr.com/tumblr_lhfpu5l3ZO1qhcviko1_500.png",
    	"http://28.media.tumblr.com/tumblr_lhfnblLRpR1qhcviko1_400.jpg",
    	"http://28.media.tumblr.com/tumblr_lhfn3bdqzy1qhcviko1_400.jpg",
	"http://cl.ly/0N451N1a031G3Y0E132B/Screen%20Shot%202012-05-03%20at%204.09.56%20PM.png",
	"http://29.media.tumblr.com/tumblr_lr64veGxDM1qhh7tbo1_500.jpg",
	"http://1.bp.blogspot.com/-uRKkekfLwBU/TmwPFpRU1TI/AAAAAAAADro/VkgBtvRiKHI/s1600/nope-cat-cats-kitten-kitty-pic-picture-funny-lolcat-cute-fun-lovely-photo-images.jpg",
	"http://www.catforum.com/photos/data/6165/lolcats-funny-picture-lalalalala.jpg"
    ]

    Yay = [
	"http://cl.ly/1K1p3Q2I3c0H21323B3R/Screen%20Shot%202012-05-03%20at%204.12.54%20PM.png",
	"http://cl.ly/1J403y3N0r3K25120Y2M/Screen%20Shot%202012-05-03%20at%204.13.31%20PM.png",
	"http://cl.ly/2r1j1N140x3y0G0I3Q0h/Screen%20Shot%202012-05-03%20at%204.14.15%20PM.png",
	"http://cl.ly/1z2u0O3d063N0g0H3k0W/Screen%20Shot%202012-05-03%20at%204.14.51%20PM.png",
	"http://cl.ly/0o2R0t1B1h350W3Z1Z3s/Screen%20Shot%202012-05-03%20at%204.15.32%20PM.png"
    ]

    match /gouté|gouter|goutay/i, :use_prefix => false

    def execute m
    	if not Time.now.hour === 16
    		m.reply "uh oh ... "
    		m.reply Nope.sample
	else
		m.reply Yay.sample
    	end
    end
end
