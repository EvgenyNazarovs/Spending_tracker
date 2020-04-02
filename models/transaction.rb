require_relative('../db/sql_runner')

class Transaction

  attr_accessor :amount, :date_time, :merchant_id, :tag_id
  attr_reader :id

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @amount  = options['amount']
    @date_time = options['date_time']
    @merchant_id = options['merchant_id']
    @tag_id = options['tag_id']
  end

  def save
    sql = "INSERT INTO transactions (amount, date_time, merchant_id, tag_id)
           VALUES ($1, $2, $3, $4)
           RETURNING *"
    values = [@amount, @date_time, @merchant_id, @tag_id]
    @id = SqlRunner.run(sql, values)[0]['id'].to_i
  end

  def update
    sql = "UPDATE transactions
           SET (amount, date_time, merchant_id, tag_id) = ($1, $2, $3, $4)
           WHERE id = $5"
    values = [@amount, @date_time, @merchant_id, @tag_id, @id]
    SqlRunner.run(sql, values)
  end

  def self.all
    sql = "SELECT & FROM transactions"
    transactions = SqlRunner.run(sql)
    return Transaction.map_items(transactions)
  end

  def self.delete_all
    sql = "DELETE FROM transactions"
    SqlRunner.run(sql)
  end

  def delete
    sql = "DELETE FROM transactions
           WHERE id = $1"
    SqlRunner.run(sql)
  end

  def self.map_items(data)
    result = data.map {|transaction| Transaction.new(transaction)}
    return result
  end


end
