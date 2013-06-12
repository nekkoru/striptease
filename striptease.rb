#Striptease - dead simple webcomic management script
#2013 Mathilda Hartnell <nekkoru@gmail.com>
#https://github.com/nekkoru/striptease

require 'sinatra'
require 'data_mapper'
require 'dm-sqlite-adapter'
require 'dm-timestamps'

#simple authentication, should work for now.
#description of the method should be in the documentation
#CHANGE THE USERNAME AND PASSWORD, LEAVE THE PARENTHESES
set :username, 'admin'
set :password, 'default'
#Don't edit any lines below this.
set :token, SecureRandom.base64(32)

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

helpers do
  def admin?
    request.cookies[settings.username]==settings.token
  end

  def protected!
    halt 401, 'Not authorized' unless admin?
  end
end

get '/' do
  @strip = Strip.last
  @prev = Strip.get(:id.lt => @strip.id, :limit => 1)
  @first = Strip.first
  erb :index
end

get '/archive' do
  @strips = Strip.all
  erb :archive
end

get '/login' do
  if admin?
    redirect '/admin_panel'
  else
    erb :admin
  end
end

post '/login' do
  if params['username']==settings.username&&params['password']==settings.password
    response.set_cookie(settings.username, :value=>settings.token)
    redirect '/admin'
  else
    "Username or password incorrect"
  end
end

get '/logout' do
  response.set_cookie(settings.username, false)
  redirect '/'
end

post '/add' do
  protected!
  unless params[:file] && (tmpfile = params[:file][:tempfile]) && (name = params[:file][:filename])
    "No file selected"
  end
  s = Strip.new
  s.filename = name
  s.title = params[:title]
  s.blurb = params[:blurb]
  s.save
  File.open(File.join(Dir.pwd,"public/uploads", name), "wb") do |f|
    while(blk = tmpfile.read(65536))
      f.write(blk)
    end
  end

  "Comic uploaded successfully. <a href=\"admin\">Return to admin panel.</a>"
end

post '/remove' do
  protected!
  params.each_value do |key|
    File.delete(File.join(Dir.pwd,"public/uploads",Strip.get(key).filename))
    Strip.get(key).destroy
  end
  redirect '/admin'
end

get '/admin' do
  protected!
  @strips = Strip.all
  erb :admin_panel
end

get '/:id' do
  @strip = Strip.get(params[:id])
  @prev = Strip.all(:id.lt => @strip.id, :order => [:id.desc]).first
  @next = Strip.all(:id.gt => @strip.id, :order =>[:id.desc]).first
  @last = Strip.last
  @first = Strip.first
  erb :strip
end

