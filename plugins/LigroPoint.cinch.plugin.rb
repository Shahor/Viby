# -*- coding: utf-8 -*-

class LigroPoint
    include Cinch::Plugin

    @@fileName = "ligropoints.yml"

    attr_accessor :points

    match(/ligropoints?(?:\s+(\S{1,20})(?:\s+([+-]?\d{1,10}))?)?/i)

    set :help => "!ligropoint [nick] [+-count] :\n * if nick is 'top' or unspecified, print the top score.\n * if count is 0 or uspecified, print the user score.\n * else give some ligropoints to the user."

    def initialize(*args)
        super
        begin
            @points = YAML::load_file(Dir.pwd + LigroPoint.fileName) #Load
        rescue
            @points = {}
        end
        @points.default = 0
    end

    def execute m, nick, count
        count = count.to_i

        if nick == m.user.nick and count != 0
            m.reply 'You can\'t change your ligropoint count!'
            return
        end

        if nick == 'top' or nick == nil
            getScores m
        else
            addPoints m, nick, count
        end
    end

    def getScores m
        top = @points.sort_by { |key, value|
            -value
        }

        for nick, count in top[0, 5]
            m.reply "#{nick.ljust(10)}: #{count}"
        end
    end

    def addPoints m, nick, count
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

        updateYaml
    end

    def updateYaml
        File.open(File.join(Dir.pwd, 'plugins', LigroPoint.fileName), 'w+') do |f|
            f.write(@points.to_yaml)
        end
    end

    def self.fileName
        @@fileName
    end
end
