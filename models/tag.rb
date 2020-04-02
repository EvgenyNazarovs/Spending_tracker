require_relative('../db/sql_runner')

class Tag

  attr_reader :id
  attr_accessor :type

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @type = options['type']
  end

  def save
    sql = "INSERT INTO tags (type)
           VALUES ($1)
           RETURNING *"
    values = [@type]
    @id = SqlRunner.run(sql, values)[0]['id'].to_i
  end

  def update
    sql = "UPDATE tags
           SET (type) = ($1)
           WHERE id = $2"
    values = [@type, @id]
    SqlRunner.run(sql, values)
  end

  def self.all
    sql = "SELECT * FROM tags"
    tags = SqlRunner.run(sql)
    return Tag.map_items(tags)
  end

  def self.delete_all
    sql = "DELETE FROM tags"
    SqlRunner.run(sql)
  end

  def delete
    sql = "DELETE FROM tags
           WHERE id = $1"
    SqlRunner.run(sql)
  end

  def self.map_items(data)
    result = data.map {|tag| Tag.new(tag)}
    return result
  end


end
