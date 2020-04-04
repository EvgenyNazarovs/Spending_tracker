require_relative('../db/sql_runner')

class Tag

  def self.all
    return ["food", "cinema", "gym", "rent", "mortgage",
            "eating out", "investment"]
  end 

end
