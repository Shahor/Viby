class DiceRoll
  include Cinch::Plugin

  # [[<repeats>#]<rolls>]d<sides>[<+/-><offset>]
  match /roll (?:(?:(\d+)#)?(\d+))?(d|D)(\d+)(?:([+-])(\d+))?/, :use_prefix => false

  def execute(m, repeats, rolls, sides, offset_op, offset)
    repeats = repeats.to_i
    repeats = 1 if repeats < 1
    rolls   = rolls.to_i
    rolls   = 1 if rolls < 1

    repeats.times do
      total = 0
      rolls.times do
        score = rand(sides.to_i) + 1
        if offset_op
          score = score.send(offset_op, offset.to_i)
        end
        total += score
      end
      m.reply "Hey #{m.user.nick} ! Your dice roll is: #{total}"
    end

  end

end

