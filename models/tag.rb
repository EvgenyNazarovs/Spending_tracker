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

  def update
    sql = "UPDATE tags
           SET (type, transaction_id) = ($1, $2)
           WHERE id = $3"
    values = [@type, @transaction_id, @id]
    SqlRunner.run(sql, values)
  end

  def self.all
    sql = "SELECT * FROM tags"
    results = SqlRunner.run(sql)
    return results.map{|tag| Tag.new(tag)}
  end

  def self.delete_all
    sql = "DELETE FROM tags"
    SqlRunner.run(sql)
  end

  def self.unique
    sql = "SELECT DISTINCT (type)
           FROM tags
           ORDER BY type"
    results = SqlRunner.run(sql)
    return results.map{|tag| Tag.new(tag)}
  end

  def self.transactions_by_type(type)
    sql = "SELECT transactions.id, transactions.amount,
           transactions.a_date, transactions.merchant_id
           FROM transactions
           INNER JOIN tags
           ON transactions.id = tags.transaction_id
           WHERE tags.type = $1"
    values = [type]
    results = SqlRunner.run(sql, values)
    return Transaction.map_items(results)
  end

  def spent_per_tag
    sql = "SELECT sum(amount)
           AS total
           FROM transactions
           INNER JOIN tags
           ON transactions.id = tags.transaction_id
           WHERE tags.type = $1"
    values = [@type]
    result = SqlRunner.run(sql,values)[0]['total'].to_i
    return nil if result == nil
    return result
  end

  def spent_per_tag_last_30_days
    sql = "SELECT sum(amount)
           AS total
           FROM transactions
           INNER JOIN tags
           ON transactions.id = tags.transaction_id
           WHERE tags.type = $1
           AND transactions.a_date >= NOW() - interval '1 month'"
    values = [@type]
    result = SqlRunner.run(sql, values)[0]['total'].to_i
    return result
  end

  def self.delete_by_transaction_id_and_type(id, type)
    sql = "DELETE FROM tags
           WHERE transaction_id = $1
           AND type = $2"
    values = [id, type]
    SqlRunner.run(sql, values)
  end

end
