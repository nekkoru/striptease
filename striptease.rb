#Striptease - dead simple webcomic client
#2013 Mathilda Hartnell <nekkoru@gmail.com>
#https://github.com/nekkoru/striptease

require 'sinatra'
require 'data_mapper'
require 'dm-sqlite-adapter'

DataMapper.setup(:default, "sqlite://#{Dir.pwd}/devel.db")

class Strip
  include DataMapper::Resource
  property :id,       Serial
  property :title,    String, :required => true
  property :posted,   DateTime
  property :filename, String, :required => true
  property :blurb,  Text
end

DataMapper.finalize

get '/' do
  erb :index, :locals => [ :strip => Strip.last, :request => :strip ]
end

get '/:id' do
  erb :index, :locals => [ :strip => Strip.get(params[:id]), :request => :strip ]
end

get '/archive' do
  erb :index, :locals => [ :strips => Strip.all, :request => :list ]
end
