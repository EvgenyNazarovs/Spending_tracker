require_relative("../models/user.rb")
require_relative("../models/merchant.rb")
require_relative("../models/transaction.rb")
require("pry-byebug")

User.delete_all
Merchant.delete_all
Transaction.delete_all


user1 = User.new({'first_name' => 'Eugene',
                 'last_name' => 'Nazarov',
                 'monthly_limit' => 1000})

user1.save

merchant1 = Merchant.new('name' => 'Tesco')
merchant2 = Merchant.new('name' => 'Old Hairdressers')
merchant3 = Merchant.new('name' => 'Waitrose')

merchant1.save
merchant2.save
merchant3.save

transaction1 = Transaction.new({'amount' => 10.0,
                               'a_date' => '2020-02-13',
                               'tag' => 'fun',
                               'user_id' => user1.id,
                               'merchant_id' => merchant2.id})
transaction2 = Transaction.new({'amount' => 20.0,
                               'a_date' => '2020-01-01',
                               'tag' => 'fun',
                               'user_id' => user1.id,
                               'merchant_id' => merchant2.id})
transaction3 = Transaction.new({'amount' => 35.0,
                               'a_date' => '2020-02-13',
                               'tag' => 'food',
                               'user_id' => user1.id,
                               'merchant_id' => merchant1.id})
transaction4 = Transaction.new({'amount' => 47.0,
                               'a_date' => '2020-01-23',
                               'tag' => 'food',
                               'user_id' => user1.id,
                               'merchant_id' => merchant3.id})
transaction5 = Transaction.new({'amount' => 7.0,
                               'a_date' => '2020-03-13',
                               'tag' => 'food',
                               'user_id' => user1.id,
                               'merchant_id' => merchant3.id})
transaction6 = Transaction.new({'amount' => 200.0,
                               'a_date' => '2020-02-13',
                               'tag' => 'electronics',
                               'user_id' => user1.id,
                               'merchant_id' => merchant1.id})

transaction1.save
transaction2.save
transaction3.save
transaction4.save
transaction5.save
transaction6.save

binding.pry
nil
