require 'digest'

require_relative 'story_data'

class DBConnection

  attr_accessor :db

  def initialize
    @db = SQLite3::Database.new 'stories.sqlite'
  end

  def upload_story(title, text)
    hash = Digest::SHA256.hexdigest("#{title}#{text}")
    if db.execute('INSERT INTO stories (title, hash, date) VALUES (?, ?, ?)', title, hash, Time.now.asctime.to_s)
      f = File.new("./stories/#{hash}", 'w')
      f.write text
      f.close
      hash
    else
      'SQLWASRIP'
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
    res = db.execute('SELECT title, date FROM stories WHERE hash = ?', hash)
    if res
      row = res[0]
      return StoryData.new(row[0], row[1], hash)
    end
    nil
  end

  def story_exists(hash)
    db.execute('SELECT * FROM stories WHERE hash = ?', hash).length > 0
  end

end