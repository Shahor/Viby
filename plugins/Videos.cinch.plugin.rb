require 'open-uri'
require 'nokogiri'

class Videos
  include Cinch::Plugin

  listen_to :channel, method: :query

  def query(m)
    urls = m.message.split.grep URI.regexp

    if urls.any?
      urls.each do |url|
        url = URI.parse(url) rescue next
        next if not url.scheme == 'http'

        if /(www\.)?(youtube|vimeo|dailymotion).*/.match url.host
          doc = Nokogiri::HTML(open(url))
          m.reply "Video: #{doc.at('meta[@property="og:title"]')['content']}"
        end

      end
    end
  end

end
