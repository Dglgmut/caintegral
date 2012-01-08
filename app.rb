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
  property :message,   String, :length => 3000

  validates_presence_of :message, :message => "A mensagem n&atilde;o pode ficar em branco"
end

class Destaques
  include DataMapper::Resource
  property :id,         Serial
  property :title,      String
  property :content,    String, :length => 3000
  property :date,       DateTime

  validates_presence_of :title, :content, :date
end

DataMapper.auto_migrate!

# Set Sinatra variables
set :app_file, __FILE__
set :root, File.dirname(__FILE__)
set :views, 'views'
#set :public, 'public'
set :haml, {:format => :html5} # default Haml format is :xhtml
enable :sessions

use Rack::Session::Cookie, :secret => ENV['COOKIE_SECRET'] || 'A1 sauce 1s so good you should use 1t on a11 yr st34ksssss'
set :default_layout, :'layouts/application'


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
  haml :propostas, :layout => :'layouts/application'
end

get '/tweets' do
  haml :tweets, :layout => :'layouts/application'
end

get '/destaques' do
  destaques = Destaques.all(:order => [:date.desc])
  haml :destaques, :layout => :'layouts/application', :locals => {:destaques => destaques}
end

get '/destaques/ver/:id' do
  destaque = Destaques.get(params[:id])
  haml :ver_destaque, :layout => :'layouts/application', :locals => {:destaque => destaque}
end

get '/destaques/novo' do
  haml :novo_destaque, :layout => :'layouts/application'
end

post '/destaques/novo' do
  title = params[:title]
  content = params[:content]

  destaque = Destaques.new(:title => title, :content => content, :date => Time.now)
  if destaque.save
    @notice = "Seu destaque foi enviado com sucesso"
    haml :index, :layout => :'layouts/application'
  else
    notice = []
    destaque.errors.each_value {|o| notice << o}
    @notice = notice[0][0]
    haml :novo_destaque, :layout => :'layouts/application'
  end
end

get '/destaques/:id/editar' do
  haml :edita_destaque, :layout => :'layouts/application'
end

post '/destaques/:id/editar' do

end

post '/destaques/:id/deletar' do

end
