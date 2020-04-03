require_relative('../db/sql_runner')

class Transaction

  attr_accessor :amount, :date_time, :tag, :merchant_id, :user_id
  attr_reader :id

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @amount  = options['amount'].to_i
    @date_time = options['date_time']
    @tag = options['tag']
    @user_id = options['user_id']
    @merchant_id = options['merchant_id']
  end

  def save
    sql = "INSERT INTO transactions (amount, date_time, tag, user_id, merchant_id)
           VALUES ($1, $2, $3, $4, $5)
           RETURNING *"
    values = [@amount, @date_time, @tag, @user_id, @merchant_id]
    @id = SqlRunner.run(sql, values)[0]['id'].to_i
  end

  def update
    sql = "UPDATE transactions
           SET (amount, date_time, tag, user_id, merchant_id) = ($1, $2, $3, $4, $5)
           WHERE id = $6"
    values = [@amount, @date_time, @tag, @user_id, @merchant_id, @id]
    SqlRunner.run(sql, values)
  end

  def self.all
    sql = "SELECT * FROM transactions"
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
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def self.map_items(data)
    result = data.map {|transaction| Transaction.new(transaction)}
    return result
  end


end
