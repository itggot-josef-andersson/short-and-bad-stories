class StoryData

  attr_accessor :title, :file_size, :date, :hash, :text

  def initialize(title, date, hash, text=nil, file_size=0)
    @title = title
    @date = date
    @hash = hash
    @text = text
    @file_size = file_size
  end

  def trim_hash?(length=20)
      if hash.length > length
        "#{hash.slice(0, length - 3)}..."
      else
        hash
      end
  end

  def trim_title?(length=45)
    if title.length > length
      "#{title.slice(0, length - 3)}..."
    else
      title
    end
  end

  def format_file_size?
    if file_size.to_s.length > 9
      "#{(file_size/(1024*1024*1024)).round(2)} GB"
    elsif file_size.to_s.length > 6
      "#{(file_size/(1024*1024*1024)).round(2)} MB"
    elsif file_size.to_s.length > 3
      "#{(file_size/1024).round(2)} KB"
    else
      "#{file_size} B"
    end
  end

end
