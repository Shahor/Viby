# -*- coding: utf-8 -*-
require 'wolfram'

class WolframAnswer
  include Cinch::Plugin

  match(/^ponette,?(.*)\?$/i, :use_prefix => false)

  def initialize(*args)
    super
    Wolfram.appid = config['appid']
  end

  def execute (m, question)
    result = Wolfram.fetch(question)
    response = result['Result'] || result['Solution']
    if not response
      for response in result
        if ['Alternate form', 'Input', 'Input interpretation', 'Plot'].index(response.title) == nil
          break
        end
      end
    end
    response = response.to_s.gsub(/\[[^\]]*\.\.\.\],?/, '') # remove messages [Some text...]
    m.reply response
  end
end
