require 'open-uri'

class Older
  include Cinch::Plugin

  MAX = 1000

  PICTURES = [
    "http://www.monaco-munich.de/images/galerie/74_dodge_monaco_blues_brothers_setpic.jpg",
    "http://f.cl.ly/items/1X2L2f0L1j0Q1M2v1N0H/b6A9M.gif",
    "http://play-auto.net/wp-content/uploads/2009/12/old-police-car.GIF",
    "http://4.bp.blogspot.com/_8gyAih3p8fY/TVGzMTLbf8I/AAAAAAAABho/Jmr8x1ZD5AI/s1600/uncle-sam.jpg",
    "http://foodfamilyfinds.com/wp-content/uploads/2010/05/illinois-police-memorial-old-police-car.jpg",
    "http://icanhascheezburger.files.wordpress.com/2009/02/funny-pictures-your-cat-does-not-care.jpg",
    "http://spoonfulpb.files.wordpress.com/2011/09/interested_lol_cat.jpg",
  ]

  SENTENCES = [
    "This link is so OLD ... (posted by %{author} at %{date})",
    "You've been olded by %{author} [posted at %{date}]",
    "Bro, you're so OLD ! %{author} posted it at %{date}",
    "Boooooyaaaaaaaaaaa ! %{author} just made you a swag older (posted on %{date})"
  ]

  listen_to :channel, method: :considerOlding

  def initialize(*args)
    super
    @links = Hash.new { |hsh, key| hsh[key] = {} }
  end

  def considerOlding(m)
    urls = m.message.split.grep URI.regexp

    if urls.any?
      urls.each do |url|
        next if not url =~ /^http/

        channel_links = @links[m.channel.name]

        if channel_links.key? url
          if channel_links[url][:author] != m.user.nick
            m.reply PICTURES.sample if rand <= 0.33
            m.reply SENTENCES.sample % channel_links[url]
          end
        else
          channel_links[url] = {
            author: m.user.nick,
            date: Time.now.strftime("%Y-%m-%d %H:%M:%S"),
          }
          channel_links.shift if channel_links.size > MAX
        end
      end
    end
  end
end
