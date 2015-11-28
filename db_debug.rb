require 'sqlite3'

db = SQLite3::Database.new 'stories.sqlite'

puts '\nCreating table "stories" if not exists'
db.execute 'CREATE TABLE IF NOT EXISTS "stories" (
  `id`	  INTEGER PRIMARY KEY AUTOINCREMENT UNIQUE,
  `title`	TEXT NOT NULL,
  `date`	TEXT DEFAULT CURRENT_TIMESTAMP,
  `hash`	TEXT NOT NULL UNIQUE
)'

puts '\nSelecting * from table "stories"'
puts db.execute('SELECT * FROM stories WHERE 1')