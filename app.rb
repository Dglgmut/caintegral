require 'rubygems'
require 'sinatra'
require 'haml'
require 'yaml'
require 'dm-core'
require 'dm-timestamps'
require 'dm-validations'
require 'dm-migrations'

# Helpers
require './lib/render_partial'


#Model/Database stuff
DataMapper.setup(:default, ENV['DATABASE_URL'] || "postgres://myapp:myapp@localhost/dev_integral")
configure :development do
  enable :logging, :dump_errors, :raise_errors
end

class Sugestoes
  include DataMapper::Resource
  property :id,        Serial
  property :name,      String
  property :mail,      String
  property :data,      DateTime
  property :message,   String

  validates_presence_of :message, :message => "A mensagem n&atilde;o pode ficar em branco"
end

DataMapper.auto_migrate!

# Set Sinatra variables
set :app_file, __FILE__
set :root, File.dirname(__FILE__)
set :views, 'views'
#set :public, 'public'
set :haml, {:format => :html5} # default Haml format is :xhtml
enable :sessions

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

  sugestao = Sugestoes.new(:name => name, :mail => mail, :message => message, :data => Time.now)
  if sugestao.save
    @notice = "Sua Sugest&atilde;o foi enviada com sucesso"
    haml :index, :layout => :'layouts/application'
  else
    notice = []
    sugestao.errors.each_value {|o| notice << o}
    @notice = notice[0][0]
    haml :sugestoes, :layout => :'layouts/application'
  end
end

get '/membros' do
  haml :membros, :layout => :'layouts/page'
end

get '/propostas' do
  haml :propostas, :layout => :'layouts/page'
end
