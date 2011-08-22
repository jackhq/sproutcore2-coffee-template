require 'rabl'
require 'sinatra'
require 'mongo_mapper'

Rabl.register!

Rabl.configure do |config|
  config.include_json_root = false
end

MongoMapper.database = 'mongolog'

class Category
  include MongoMapper::Document
  key :name, String
end

# Category.delete_all
# 
# ['basic','coworker','best'].each do |c|
#   Category.create(:name => c)
# end

class Friend
  include MongoMapper::Document

  key :name, String
  key :category, String

  timestamps!
end

#Friend.delete_all
#Friend.create(:name => 'Ellen', :category => 'Family')

class FriendsApp < Sinatra::Base
  set :root, File.dirname(__FILE__)

  get '/' do
    redirect 'index.html'
  end

  get '/categories' do
    @categories = Category.all
    render :rabl, :categories, :format => 'json'
  end

  get '/friends' do
    @friends = Friend.all
    render :rabl, :friends, :format => 'json'
  end

  post '/friends' do
    puts params[:friend]
    @friend = Friend.create(params[:friend])
    render :rabl, :friend, :format => 'json'
  end

  get '/friends/:id' do
    @friend = Friend.get(params[:id])
    render :rabl, :friend, :format => 'json'
  end

  put '/friends/:id' do
    @friend = Friend.get(params[:id])
    @friend.update(params[:todo])
    render :rabl, :friend, :format => 'json'
  end

  delete '/friends/:id' do
    @friend = Friend.get(params[:id])
    @friend.destroy
  end

end