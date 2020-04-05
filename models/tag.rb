require_relative('../db/sql_runner')

class Tag

  attr_accessor :type, :transaction_id
  attr_reader :id

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @type = options['type']
    @transaction_id = options['transaction_id'].to_i
  end

  def save
    sql = "INSERT INTO tags (type, transaction_id)
           VALUES ($1, $2)
           RETURNING *"
    values = [@type, @transaction_id]
    @id = SqlRunner.run(sql, values)[0]['id'].to_i
  end

  def self.delete_all
    sql = "DELETE FROM tags"
    SqlRunner.run(sql)
  end

end
