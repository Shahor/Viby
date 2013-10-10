# -*- coding: utf-8 -*-
require 'open-uri'
require 'json'
require 'base64'

class Caniuse
    include Cinch::Plugin

    attr_accessor :featuresCache
    attr_accessor :featuresCacheDate
    attr_accessor :fileCache
    attr_accessor :fileCacheDate

    match /caniuse (.*)/, :use_prefix => true

    def initialize(*args)
        super

        resetCache
    end

    def execute m, topic
        topic.strip!
        if featuresCacheIsOld?
            m.reply "First launch right ? Lemme cache the features list for you first..."
            buildFeaturesCache
        end

        found = false
        m.reply "Hold on, let me query that for you"
        @featuresCache.each do |metadata|
            if metadata['name'] =~ /#{topic}/
                if fileCacheIsOld? metadata['name']
                    buildFileCache(metadata['name'], metadata['url'])
                end

                content = JSON::parse(Base64::decode64(@fileCache[metadata['name']]['content']))

                ["firefox", "chrome", "ie"].each do |browser|
                    content['stats'][browser].each do |version, availability|
                        if availability =~ /y/
                            found = true
                            m.reply "#{browser.capitalize} : #{version}+"
                            break
                        end
                    end
                end
            end
        end

        m.reply "Uh oh, didn't find anything... Gimme a hand ? Try this : http://caniuse.com/#search=#{URI::encode topic}" if not found
    end

    protected

    def resetCache
        @featuresCache = nil
        @featuresCacheDate = nil
        @fileCache = {}
        @fileCacheDate = {}
    end

    def buildFeaturesCache
        @featuresCache = JSON::parse open("https://api.github.com/repos/fyrd/caniuse/contents/features-json").read
        @featuresCacheDate = Time.now
    end

    def buildFileCache fileName, fileUrl
        @fileCache[fileName] = JSON::parse open(fileUrl).read
        @fileCacheDate[fileName] = Time.now
    end

    def fileCacheIsOld? fileName
        @fileCacheDate[fileName].nil? ? true : @fileCacheDate[fileName] < Time.now - 604800
    end

    def featuresCacheIsOld?
        # Older than a week
        @featuresCache.nil? ? true : @featuresCacheDate < Time.now - 604800
    end
end