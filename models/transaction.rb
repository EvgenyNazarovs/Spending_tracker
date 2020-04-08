require_relative('../db/sql_runner')

class Transaction

  attr_accessor :amount, :a_date, :merchant_id
  attr_reader :id

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @amount  = options['amount'].to_i
    @a_date = options['a_date']
    @merchant_id = options['merchant_id'].to_i
  end

  def save
    sql = "INSERT INTO transactions (amount, a_date, merchant_id)
           VALUES ($1, $2, $3)
           RETURNING *"
    values = [@amount, @a_date, @merchant_id]
    @id = SqlRunner.run(sql, values)[0]['id'].to_i
  end

  def update
    sql = "UPDATE transactions
           SET (amount, a_date, merchant_id) = ($1, $2, $3)
           WHERE id = $4"
    values = [@amount, @a_date, @merchant_id, @id]
    SqlRunner.run(sql, values)
  end

  # returns all transaction from recent to old

  def self.sorted_by_month
    sql = "SELECT * FROM transactions
           ORDER BY a_date DESC"
    results = SqlRunner.run(sql)
    return Transaction.map_items(results)
  end

  # finds transactions for specific month

  def self.find_by_month(yyyy_mm)
    sql = "SELECT * FROM transactions
           WHERE to_char(a_date, 'YYYY-MM') = $1"
    values = [yyyy_mm]
    transactions = SqlRunner.run(sql, values)
    return Transaction.map_items(transactions)
  end

  def self.convert_to_date
    transactions = self.sorted_by_month
    return transactions.each {|x| x.a_date = Date.parse(x.a_date)}
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

  def self.delete(id)
    sql = "DELETE FROM transactions
           WHERE id = $1"
    values = [id]
    SqlRunner.run(sql, values)
  end

  def self.monthly_spent(yyyy_mm)
    sql = "SELECT sum(amount)
           AS total
           FROM transactions
           WHERE to_char(a_date, 'YYYY-MM') = $1"
    values = [yyyy_mm]
    return total = SqlRunner.run(sql, values)[0]['total'].to_i
  end

  def self.total_spent_this_month
    sql = "SELECT sum(amount)
           AS total
           FROM transactions
           WHERE date_trunc('month', a_date) =
           date_trunc('month', CURRENT_DATE)"
    result = SqlRunner.run(sql)[0]['total'].to_i
    return result
  end

def self.total_spent_last_month
  sql = "SELECT sum(amount)
         AS total
         FROM transactions
         WHERE a_date >= date_trunc('month', current_date - interval '1 month')
         AND a_date < date_trunc('month', current_date)"
  result = SqlRunner.run(sql)[0]['total'].to_i
  return result
end

  def merchant
    sql = "SELECT * FROM merchants
           WHERE id = $1"
    values = [@merchant_id]
    result = SqlRunner.run(sql, values).first
    return Merchant.new(result)
  end

  def tags
    sql = "SELECT * FROM tags
           WHERE transaction_id = $1"
    values = [@id]
    results = SqlRunner.run(sql, values)
    return results.map {|result| Tag.new(result)}
  end

  def show_tags_in_string
    tags = tags()
    string = tags.reduce("") {|string, tag| string + tag.type.to_s + ","}
    return string.chop
  end

  def self.find_by_id(id)
    sql = "SELECT * FROM transactions
           WHERE id = $1"
    values = [id]
    result = SqlRunner.run(sql, values).first
    return Transaction.new(result)
  end

  def self.find_last_30_days
    sql = "SELECT * FROM transactions
           WHERE a_date >= NOW() - interval '1 month'"
    results = SqlRunner.run(sql, values)
    return Transaction.map_items(results)
  end

  def self.map_items(data)
    result = data.map {|transaction| Transaction.new(transaction)}
    return result
  end

end
