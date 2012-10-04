#BUG 1dO

class Roll
  include Cinch::Plugin

  # [[<repeats>#]<rolls>]d<sides>
  match /roll (?:(?:(\d+)#)?(\d+))?(?:d|D)(\d+)/

  set :help => "!roll [[<repeats>#]<rolls>]d<sides>"

  def execute(m, repeats, rolls, sides)
    repeats = (repeats || 1).to_i
    rolls = (rolls || 1).to_i
    sides = (sides || 1).to_i

    if repeats < 1 or repeats > 10 or rolls < 1 or rolls > 10 or sides < 1 or sides > 100
      m.reply "Hey #{m.user.nick}, U MAD BRO !"
      return
    end

    repeats.times do
      total = 0
      rolls.times do
        score = rand(sides) + 1
        total += score
      end
      m.reply "Hey #{m.user.nick} ! Your dice roll is: #{total}"
    end

  end

end

