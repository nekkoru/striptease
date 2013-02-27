#Striptease - dead simple webcomic client
#2013 Mathilda Hartnell <nekkoru@gmail.com>
#https://github.com/nekkoru/striptease

require 'rubygems'
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
  @strip = Strip.last
  erb :index, :locals => { :strip => @strip }
end

get '/archive' do
  @strips = Strip.all
  erb :archive, :locals => { :strips => @strips }
end

get '/:id' do
  @strip = Strip.get(params[:id])
  erb :strip, :locals => { :strip => @strip }
end


