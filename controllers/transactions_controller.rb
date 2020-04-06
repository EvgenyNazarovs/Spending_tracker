require('sinatra')
require('sinatra/contrib/all') if development?
require('pry-byebug')
require_relative('../models/transaction.rb')
require_relative('../models/merchant.rb')
require_relative('../models/user.rb')
require_relative('../models/tag.rb')
also_reload('../models/*')

# TRANSACTION NEW

get '/transactions/new' do
  @merchants = Merchant.all
  @tags = Tag.unique
  erb(:"transactions/new")
end

post '/transactions/add' do
  transaction = Transaction.new(params)
  transaction.save
  tag1 = Tag.new({'type' => params[:tags][:type1],
                  'transaction_id' => transaction.id})
  tag2 = Tag.new({'type' => params[:tags][:type2],
                  'transaction_id' => transaction.id})
  tag1.save
  tag2.save
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

get '/transactions/:id/delete' do
  Transaction.delete(params[:id])
  redirect to("/transactions/view")
end

get '/transactions/:id/edit' do
  @transaction = Transaction.find_by_id(params[:id])
  @merchants = Merchant.all
  erb(:"transactions/edit")
end
