# -*- coding: utf-8 -*-

class LigroPoint
  include Cinch::Plugin

  match(/ligropoints?(?:\s+(\S{1,20})(?:\s+([+-]?\d{1,10}))?)?/i)

  set :help => "!ligropoint [nick] [+-count] :\n * if nick is 'top' or unspecified, print the top score.\n * if count is 0 or uspecified, print the user score.\n * else give some ligropoints to the user."

  def initialize(*args)
    super
    @points = {}
    @points.default = 0
  end

  def execute m, nick, count
    count = count.to_i

    if nick == 'top' or nick == nil
      top = @points.sort_by {|key, value| -value}
      for nick, count in top[0, 5]
        m.reply "#{nick.ljust(10)}: #{count}"
      end
    elsif nick == m.user.nick and count != 0
      m.reply 'You can\'t change your ligropoint count!'
    else
      @points[nick] += count
      if @points[nick] == 0
        @points.delete(nick)
      end
      if count == 0
        m.reply "#{nick} has #{@points[nick]} ligropoints"
      elsif count < 0
        m.reply "#{m.user.nick} removes #{-count} ligropoints to #{nick}"
      else
        m.reply "#{m.user.nick} gives #{count} ligropoints to #{nick}"
      end
    end
  end

end
