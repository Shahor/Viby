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
        for message in @messages
            time = DateTime.now.strftime(message['format'])
            if message['time'] == time
                Channel(message['chan']).send message['msg']
            end
        end
    end
end

