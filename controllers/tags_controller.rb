require('sinatra')
require('sinatra/contrib/all') if development?
require('pry-byebug')
require_relative('../models/transaction.rb')
require_relative('../models/merchant.rb')
require_relative('../models/tag.rb')
also_reload('../models/*')

get '/tags/view' do
  @tags = Tag.unique
  erb(:"tags/view")
end

get '/tags/:id/delete' do
  @type = params[:id].split('-')[1].to_s
  @transaction_id = params[:id].split('-')[0].to_i
  Tag.delete_by_trx_id_and_type(@transaction_id, @type)
  erb(:"tags/untag")
end

get '/tags/:id/transactions' do
  @type = params[:id].to_s
  @transactions = Tag.transactions_by_type(params[:id])
  erb(:"tags/transactions")
end
