# -*- coding: utf-8 -*-

class Wat
  include Cinch::Plugin

  listen_to :channel, method: :query
  set :help => "You deaf nigga?"

  def initialize(*args)
    super
    @previous = {}
  end

  def query m
    chan = m.channel.name[1..-1]
    if m.message.match /^(wa+t|quoi)\s*(\?*)$/i
      m.reply "IL A DIT: \"#{@previous[chan].upcase}\", #{m.user}" if @previous[chan]
    end
    @previous[chan] = m.message.strip
  end

end
