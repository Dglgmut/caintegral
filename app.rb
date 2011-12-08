require 'rubygems'
require 'sinatra'
require 'haml'
require 'yaml'


# Helpers
require './lib/render_partial'

# Set Sinatra variables
set :app_file, __FILE__
set :root, File.dirname(__FILE__)
set :views, 'views'
set :public, 'public'
set :haml, {:format => :html5} # default Haml format is :xhtml

# Application routes
get '/' do
  haml :index, :layout => :'layouts/application'
end

get '/sugestoes' do
  haml :sugestoes, :layout => :'layouts/application'
end

post '/sugestoes' do
  name = params[:name]
  mail = params[:mail]
  message = params[:message]

  f = File.new "db.troll", "a"
  f.puts name + '_' + mail + '_' + message
  f.close

  haml :index, :layout => :'layouts/application'
end

get '/membros' do
  haml :membros, :layout => :'layouts/page'
end

get '/propostas' do
  haml :propostas, :layout => :'layouts/page'
end
