require('sinatra')
require('sinatra/contrib/all') if development?
require('pry-byebug')
require_relative('../models/transaction.rb')
require_relative('../models/merchant.rb')
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
  @transactions = Transaction.sorted_by_month
  erb(:"transactions/view")
end

post '/transactions/success' do
  transaction = Transaction.new(params)
  transaction.update
  tag = Tag.new({'type' => params[:type],
                 'transaction_id' => transaction.id})
  tag.save
  redirect to("/transactions/view")
end

post '/transactions/monthly_view' do
  @transactions = Transaction.find_by_month(params[:month])
  @total_spent = Transaction.monthly_spent(params[:month])
  erb(:"transactions/monthly_view")
end

# view stats

get '/transactions/stats' do
  @this_month = Transaction.total_spent_this_month
  @last_month = Transaction.total_spent_last_month
  erb(:"transactions/stats")
end

get '/transactions/:id/delete' do
  Transaction.delete(params[:id])
  redirect to("/transactions/view")
end

get '/transactions/:id/edit' do
  @transaction = Transaction.find_by_id(params[:id])
  @merchants = Merchant.all
  @tags = Tag.unique
  erb(:"transactions/edit")
end
