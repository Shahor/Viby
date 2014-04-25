require 'open-uri'
require 'sqlite3'

class Older
  include Cinch::Plugin

  listen_to :channel, method: :considerOlding

  def initialize(*args)
    super
    @db = SQLite3::Database.new( "old.db" )
    @db.execute <<-SQL
      CREATE TABLE IF NOT EXISTS urls (
        id INTEGER PRIMARY KEY AUTOINCREMENT, 
        link TEXT, 
        who TEXT, 
        tag TEXT, 
        date DATETIME
      );
    SQL
    @db.results_as_hash = true
  end

  def considerOlding(m)
    if m.message =~ /^!url ([^\s]*)(\s(\d+))?/
      old = @db.execute "SELECT * FROM urls WHERE link LIKE ?", "%#{$1}%"
      if !old.empty?
        # Take last url by default
        idx = $3 ? $3.to_i - 1 : old.length - 1
        # stay in bounds
        idx = [idx, old.length - 1].min
        row = old[idx]
        m.reply "#{row['link']} by #{row['who']}, #{row['date']} - (url #{idx+1}/#{old.length})"
      else
        m.reply "No results"
      end
    else
      urls = m.message.split.grep URI.regexp
      if urls.any?
        urls.each do |url|
          is_old = @db.execute "SELECT * FROM urls WHERE link = ?", url
          if !is_old.empty?
            m.reply "Old"
          else 
            @db.execute "INSERT INTO urls (link, who, tag, date) VALUES (?, ?, ?, ?)", url, m.user.nick, "", DateTime.now.strftime('%d/%m/%Y %H:%M:%S')
          end
        end
      end
    end
  end
end