require_relative('../db/sql_runner')

class User

  attr_reader :id
  attr_accessor :first_name, :last_name, :monthly_limit

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @first_name = options['first_name']
    @last_name = options['last_name']
    @monthly_limit = options['monthly_limit']
  end

  def save
    sql = "INSERT INTO users (first_name, last_name, monthly_limit)
           VALUES ($1, $2, $3)
           RETURNING *"
    values = [@first_name, @last_name, @monthly_limit]
    @id = SqlRunner.run(sql, values)[0]['id'].to_i
  end

  def update
    sql = "UPDATE users
           SET (first_name, last_name, monthly_limit)
           VALUES ($1, $2, $3)
           WHERE id = $4"
    values = [@first_name, @last_name, @monthly_limit, @id]
    SqlRunner.run(sql, values)
  end

  def self.delete_all
    sql = "DELETE FROM users"
    SqlRunner.run(sql)
  end

  def display_monthly_limit
    sql = "SELECT * FROM users
           WHERE id = $1"
    values = [@id]
    result = SqlRunner.run(sql, values)[0]['monthly_limit'].to_i
    return result
  end

  def transactions
    sql = "SELECT * FROM transactions
           WHERE user_id = $1"
    values = [@id]
    transactions = SqlRunner.run(sql, values)
    return Transaction.map_items(transactions)
  end

  def total_spent
    transactions = transactions()
    return transactions.reduce(0) {|sum, transaction| sum + transaction.amount}
  end





end
