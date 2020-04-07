require_relative('../db/sql_runner')

class Budget

  attr_accessor: :monthly_limit, :total

  def initialize()
    @monthly_limit = 0
    @total = 0
  end

  def self.total_spent

  end 

end
