# -*- coding: utf-8 -*-

class Ligro
  include Cinch::Plugin

  match(/ligropoint\s+(\S{1,20})(?:\s+([+-]?\d{1,10})+)?/i)

  set :help => "!ligropoint <nick> [+-count], !ligropoint top"

  def initialize(*args)
    super
    @points = {}
    @points.default = 0
  end

  def execute m, nick, count
    count = count.to_i

    if nick == 'top'
      top = @points.sort_by {|key, value| -value}
      for nick, count in top[0, 5]
        m.reply "#{nick.ljust(10)}: #{count}"
      end
    elsif nick == m.user.nick and count != 0
      m.reply 'You can\'t change your ligropoint count!'
    else
      @points[nick] += count
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
