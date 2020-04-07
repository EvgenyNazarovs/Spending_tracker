require('sinatra')
require('sinatra/contrib/all') if development?
require('pry-byebug')
require_relative('../models/transaction.rb')
require_relative('../models/merchant.rb')
require_relative('../models/user.rb')
require_relative('../models/tag.rb')
also_reload('../models/*')

get '/tags/stats' do
  @tags = Tag.unique
  erb(:"tags/stats")
end

post '/tags/:id/delete' do

  erb(:"tags/transactions")
end

get '/tags/:id/transactions' do
  @type = params[:id]
  @transactions = Tag.transactions_by_type(params[:id])
  erb(:"tags/transactions")
end
