require_relative('../db/sql_runner')

class Transaction

  attr_accessor :amount, :a_date, :tag, :merchant_id, :user_id
  attr_reader :id

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @amount  = options['amount'].to_i
    @a_date = options['a_date']
    @tag = options['tag']
    @user_id = options['user_id']
    @merchant_id = options['merchant_id']
  end

  def save
    sql = "INSERT INTO transactions (amount, a_date, tag, user_id, merchant_id)
           VALUES ($1, $2, $3, $4, $5)
           RETURNING *"
    values = [@amount, @a_date, @tag, @user_id, @merchant_id]
    @id = SqlRunner.run(sql, values)[0]['id'].to_i
  end

  def update
    sql = "UPDATE transactions
           SET (amount, a_date, tag, user_id, merchant_id) = ($1, $2, $3, $4, $5)
           WHERE id = $6"
    values = [@amount, @a_date, @tag, @user_id, @merchant_id, @id]
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

  def self.find_by_user_id(user_id)
    sql = "SELECT * FROM transactions
           WHERE user_id = $1"
    values = [user_id]
    transactions = SqlRunner.run(sql)
    return Transaction.map_items(transactions)
  end

  def self.convert_to_date
    transactions = self.all
    return transactions.each {|x| x.a_date = Date.parse(x.a_date)}
  end

  def self.sort_by_year_month
    transactions = self.convert_to_date
    return transactions.group_by {|x| [x.a_date.mon, x.a_date.year]}
  end

  def self.sort_by_yearmonth(year, month)
    transactions = self.convert_to_date
    return transactions.select {|x, v| x.a_date.mon == month && x.a_date.year == year}
  end



  def self.months
    transactions = Transaction.sort_by_year_month
    months = Date::MONTHNAMES
    updated = transactions.each do |key, values|
      key[0] = months[key[0]]
    end
    return updated
  end

end
