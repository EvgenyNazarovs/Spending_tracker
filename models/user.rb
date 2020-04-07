require_relative('../db/sql_runner')

class User

  attr_accessor :budget

def initialize(budget)
  @budget = budget
end

end
