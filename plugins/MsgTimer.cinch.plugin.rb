# -*- coding: utf-8 -*-
require 'cinch'
require 'date'

class MsgTimer
    include Cinch::Plugin

    def initialize(*args)
      super
      @messages = []
      for message in config
          @messages.push(message)
      end
    end


    timer 60, method: :timed
    def timed
        time = DateTime.now.strftime("%H:%M")
        for message in @messages
            if message['time'] == time
                Channel(message['chan']).send message['msg']
            end
        end
    end
end

