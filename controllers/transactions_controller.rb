require('sinatra')
require('sinatra/contrib/all') if development?
require('pry-byebug')
require_relative('../models/transaction.rb')
require_relative('../models/merchant.rb')
require_relative('../models/user.rb')
require_relative('../models/tag.rb')
also_reload('../models/*')

# TRANSACTION NEW

get '/transactions/add' do
  @merchants = Merchant.all
  erb(:"transactions/new")
end

post '/transactions/added' do
  transaction = Transaction.new(params)
  transaction.save
  redirect to("/transactions/view")
end

# VIEW TRANSACTIONS

get '/transactions/view' do
  @transactions = Transaction.months
  erb(:"transactions/view")
end

post '/transactions/success' do
  transaction = Transaction.new(params)
  transaction.update
  redirect to("/transactions/view")
end

get '/transactions/:id/edit' do
  @transaction = Transaction.find_by_id(params[:id])
  @merchants = Merchant.all
  erb(:"transactions/edit")
end
