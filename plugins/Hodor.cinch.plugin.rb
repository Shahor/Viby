# -*- coding: utf-8 -*-

class Hodor
  include Cinch::Plugin

  match /h(o)+d(o)+(r)+/i, :use_prefix => false

  set :help => "HODOR !"

  def execute m, message
    m.reply ["Hodor !", "Hodor hodor, hodor ?", "Hodor hodor.", "Hod-d-d-dor", "Hodor, hodor :D", "Hodor"].sample
  end

end