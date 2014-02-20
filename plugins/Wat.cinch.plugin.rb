# -*- coding: utf-8 -*-

class Wat
  include Cinch::Plugin

  listen_to :channel, method: :query
  set :help => "You deaf nigga?"

  def initialize(*args)
    super
    @previous = nil
  end

  def query m
    if m.message.match /^(wa+t|quoi)(\?*)$/i
      m.reply "IL A DIT: \"#{@previous.upcase}\""
    end
    @previous = m.message.strip
  end

end
