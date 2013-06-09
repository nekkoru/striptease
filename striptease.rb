#Striptease - dead simple webcomic management script
#2013 Mathilda Hartnell <nekkoru@gmail.com>
#https://github.com/nekkoru/striptease

require 'sinatra'
require 'data_mapper'
require 'dm-sqlite-adapter'
reqiore 'dm-timestamps'

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

#simple authentication, to be replaced later
#description of the method should be in the documentation
set :username, 'admin'
set :token, SecureRandom.base64(32)
set :password, 'default'

helpers do
  def admin?
    request.cookies[settings.username]==settings.token
  end

  def protected!
    halt 401, 'Not authorized' unless admin?
  end
end



get '/' do
  erb :index, :locals => [ :strip => Strip.last, :request => :strip ]
end

get '/archive' do
  erb :index, :locals => [ :strips => Strip.all, :request => :list ]
end

get '/admin' do
  if admin?
    redirect '/admin_panel'
  else
    erb :admin
  end
end

post '/login' do
  if params['username']==settings.username&&params['password']==settings.password
    response.set_cookie(settings.username, :value=>settings.token)
    redirect '/admin_panel'
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
    redirect '/admin_panel'
  end
  s = Strip.new
  s.filename = name
  s.title = params[:title]
  s.blurb = params[:blurb]
  s.posted = [Time.now.year, Time.now.month, Time.now.day].join(-)
  s.save
  File.open(File.join(Dir.pwd,"public/uploads", name), "wb") do |f|
    while(blk = tmpfile.read(65536))
      f.write(blk)
    end
  end

  "Comic uploaded successfully. <a href=\"admin_panel\">Return to admin panel.</a>"
end

post '/remove' do
  protected!
  params.each_value do |key|
    File.delete(File.join(Dir.pwd,"public/uploads",key,Strip.get(key).filename)
    Strip.get(key).destroy
  end
  redirect '/admin_panel'
end

  redirect '/admin_panel'
end

get '/admin_panel' do
  protected!
  erb :admin_panel
end

get '/:id' do
 @strip = Strip.get(params[:id]
 erb :strip
end

