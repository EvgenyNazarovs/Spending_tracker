require('sinatra')
require('sinatra/contrib/all') if development?
require('pry-byebug')
require_relative('../models/transaction.rb')
require_relative('../models/merchant.rb')
require_relative('../models/user.rb')
require_relative('../models/tag.rb')
also_reload('../models/*')

# INDEX

get '/transactions' do
  erb(:"transactions/index")
end

# TRANSACTION NEW

# get '/transactions/add' do
#   @users = User.all
#   @merchants = Merchant.all
#   @tags = Tag.all
#   erb(:"transactions/new")
# end
#
# post '/transactions/added' do
#   transaction = Transaction.new(params)
#   transaction.save
#   erb(:"transactions/added")
# end

# VIEW TRANSACTIONS

get '/transactions/view' do
  @transactions = Transaction.months
  erb(:"transactions/view")
end
