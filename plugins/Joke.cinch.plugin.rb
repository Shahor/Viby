# -*- coding: utf-8 -*-

class Joke
  include Cinch::Plugin

  match /(?:blague|joke)/i

  set :help => "!joke or !blague"

  def initialize(*args)
    super
    @jokes = File.read(File.join(ROOT, 'plugins', 'Joke.list')).split(/\n\n/)
  end

  def execute m
    m.reply @jokes[rand(@jokes.size)]
  end

end
