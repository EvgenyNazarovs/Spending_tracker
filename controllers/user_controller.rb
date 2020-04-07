# require('sinatra')
# require('sinatra/contrib/all')
# require('pry-byebug')
# require_relative('../models/user.rb')
# require_relative('../models/transaction.rb')
# also_reload('../models/*')
#
# # USER INDEX
#
# get '/user' do
#   erb(:"user/index")
# end
#
# # USER UPDATE MONTHLY LIMIT
#
# post '/user/limit' do
#   @user = User.find_by_id(params['id'].to_i)
#   @user.monthly_limit = params['monthly_limit'].to_i
#   @user.update
#   erb(:"user/limit")
# end
