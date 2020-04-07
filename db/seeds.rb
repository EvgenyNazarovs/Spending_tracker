require_relative("../models/tag.rb")
require_relative("../models/merchant.rb")
require_relative("../models/transaction.rb")
require("pry-byebug")


Merchant.delete_all
Transaction.delete_all
Tag.delete_all

merchant1 = Merchant.new('name' => 'Tesco')
merchant2 = Merchant.new('name' => 'Old Hairdressers')
merchant3 = Merchant.new('name' => 'Waitrose')

merchant1.save
merchant2.save
merchant3.save

transaction1 = Transaction.new({'amount' => 10.0,
                                'a_date' => '2020-04-02',
                                'merchant_id' => merchant2.id})
transaction2 = Transaction.new({'amount' => 20.0,
                               'a_date' => '2020-04-01',
                               'merchant_id' => merchant2.id})
transaction3 = Transaction.new({'amount' => 35.0,
                               'a_date' => '2020-02-13',
                               'merchant_id' => merchant1.id})
transaction4 = Transaction.new({'amount' => 47.0,
                               'a_date' => '2020-01-23',
                               'merchant_id' => merchant3.id})
transaction5 = Transaction.new({'amount' => 7.0,
                               'a_date' => '2020-03-13',
                               'merchant_id' => merchant3.id})
transaction6 = Transaction.new({'amount' => 200.0,
                               'a_date' => '2020-04-13',
                               'merchant_id' => merchant1.id})

transaction1.save
transaction2.save
transaction3.save
transaction4.save
transaction5.save
transaction6.save

tag1 = Tag.new({'type' => 'fun', 'transaction_id' => transaction1.id})
tag2 = Tag.new({'type' => 'fun', 'transaction_id' => transaction2.id})
tag3 = Tag.new({'type' => 'food', 'transaction_id' => transaction3.id})
tag4 = Tag.new({'type' => 'fun', 'transaction_id' => transaction4.id})
tag5 = Tag.new({'type' => 'social', 'transaction_id' => transaction5.id})
tag6 = Tag.new({'type' => 'travel', 'transaction_id' => transaction6.id})
tag7 = Tag.new({'type' => 'social', 'transaction_id' => transaction1.id})

tag1.save
tag2.save
tag3.save
tag4.save
tag5.save
tag6.save
tag7.save

binding.pry
nil
