require 'sqlite3'
require 'date'

class ScoreDatabase
  def initialize(db_name)
    @db = SQLite3::Database.new(db_name)
    create_table
  end

  def create_table
    query = <<-SQL
      CREATE TABLE IF NOT EXISTS scores (
        id INTEGER PRIMARY KEY,
        player_name TEXT,
        score INTEGER,
        created_at DATETIME
      );
    SQL

    @db.execute(query)
  end

  def insert_score(player_name, score)
    created_at = DateTime.now.to_s
    query = 'INSERT INTO scores (player_name, score, created_at) VALUES (?, ?, ?);'
    @db.execute(query, [player_name, score, created_at])
  end

  def get_top_five_scores()
    query = 'SELECT player_name, score, created_at FROM scores ORDER BY score DESC LIMIT ?;'
    rows = @db.execute(query, [5])

    formatted_scores = rows.map do |row|
      created_at = DateTime.parse(row[2])
      formatted_date_time = created_at.strftime('%d/%m/%Y %H:%M')
      { player_name: row[0], score: row[1], created_at: formatted_date_time }
    end

    formatted_scores
  end
end