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

  # def show_date
  #   date = a_date()
  #   Date.strftime('%B, ')
  # end

  def self.map_items(data)
    result = data.map {|transaction| Transaction.new(transaction)}
    return result
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
    return updated = transactions.each do |key, values|
      key[0] = months[key[0]]
    end
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


end
