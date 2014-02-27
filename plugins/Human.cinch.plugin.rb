# -*- coding: utf-8 -*-

class Human
  include Cinch::Plugin
  require 'cleverbot'

  listen_to :channel, method: :query

  def initialize(*args)
    super
    @copycat_counter = 1
    @last_copycat = nil
    @loktar_counter = 1
    @last_loktar = nil
    @loktar_trigger = config['flood_trigger'] || 10
  end

  def query m
    copycat m
    be_polite m
    enough_loktar m
  end

  def copycat m
    message = m.message.strip.downcase
    if message == @last_copycat
      @copycat_counter += 1
      m.reply m.message if @copycat_counter == 3
    else
      @last_copycat = message
      @copycat_counter = 1
    end
  end

  def be_polite m
    if m.message =~ /#{self.bot.nick}/i
      bot = Cleverbot::Client.new
      m.reply "#{m.user}: #{bot.write m.message.sub!(/#{self.bot.nick}/i, '')}"
    end
  end

  def enough_loktar m
    user = m.user
    if user == @last_loktar
      @loktar_counter += 1
      m.reply "Ca suffit #{user}, tu te tais ou JE te tais ! T’es toléré ici !... TOLÉRÉ !" if @loktar_counter == @loktar_trigger
    else
      @last_loktar = user
      @loktar_counter = 1
    end
  end
end