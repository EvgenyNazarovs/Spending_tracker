require('sinatra')
require('sinatra/contrib/all') if development?
require('pry')
require_relative('../models/transaction.rb')
require_relative('../models/merchant.rb')
require_relative('../models/user.rb')
require_relative('../models/tag.rb')
also_reload('../models/*')

# VIEW MERCHANTS

get '/merchants/view' do
  @merchants = Merchant.all
  erb(:'/merchants/view')
end

get '/merchants/add' do
  erb(:'merchants/add')
end

post '/merchants' do
  merchant = Merchant.new(params)
  merchant.save
  redirect to('/merchants/view')
end

post '/merchants/success' do
  merchant = Merchant.find_by_id(params[:id])
  merchant.name = params[:name]
  merchant.update
  redirect to("/merchants/view")
end

get '/merchants/:id' do
  @merchant = Merchant.find_by_id(params[:id])
  @transactions = @merchant.transactions
  erb(:'/merchants/transactions')
end

# EDIT MERCHANT

get '/merchants/:id/edit' do
  @merchant = Merchant.find_by_id(params[:id])
  erb(:'/merchants/edit')
end
