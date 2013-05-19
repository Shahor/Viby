# -*- coding: utf-8 -*-

class Human
  include Cinch::Plugin

  listen_to :channel, method: :query

  def initialize(*args)
    super
    @counter = 1
    @last = nil
  end

  def query m
    copycat m
    be_polite m
  end

  def copycat m
    message = m.message.strip.downcase
    if message == @last
      @counter += 1
      m.reply m.message if @counter == 3
    else
      @last = message
      @counter = 1
    end
  end

  def be_polite m
    if m.message =~ /#{self.bot.nick}/i
      if m.message =~ /tg|gueule|saoule|ferme/i
        return m.reply "C'est toi arrêtez !"
      end
      return m.reply "Plaît-il ?"
    end
  end
end