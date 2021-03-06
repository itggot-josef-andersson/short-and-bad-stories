require 'digest'

require_relative 'story_data'

class DBConnection

  attr_accessor :db

  def initialize
    @db = SQLite3::Database.new 'stories.sqlite'
    puts "\nCreating table 'stories' if not exists\n"
    db.execute 'CREATE TABLE IF NOT EXISTS "stories" (
      `id`	  INTEGER PRIMARY KEY AUTOINCREMENT UNIQUE,
      `title`	TEXT NOT NULL,
      `date`	TEXT DEFAULT CURRENT_TIMESTAMP,
      `hash`	TEXT NOT NULL UNIQUE
    )'
  end

  def upload_story(title, text)
    hash = Digest::SHA256.hexdigest("#{title}#{text}").to_s
    if db.execute('INSERT INTO stories (title, hash, date) VALUES (?, ?, ?)', title, hash, Time.now.asctime.to_s)
      f = File.new("./stories/#{hash}", 'w')
      f.write text
      f.close
      hash
    else
      'SQLError'
    end
  end

  def latest_stories(limit=20)
    res = db.execute('SELECT title, date, hash FROM stories ORDER BY date DESC LIMIT ?', limit)
    if res
      output = []
      res.each do |row|
        output << StoryData.new(row[0], row[1], row[2], nil, File.size("./stories/#{row[2]}"))
      end
      return output
    end
    nil
  end

  def get_story_data_from_hash(hash)
    res = db.execute('SELECT title, date FROM stories WHERE hash LIKE ?', hash)
    if res && res.length
      res = res[0]
      return StoryData.new(res[0], res[1], hash)
    end
    nil
  end

  def story_exists(hash)
    db.execute('SELECT * FROM stories WHERE hash LIKE ?', hash).length > 0
  end

end