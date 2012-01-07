require 'rubygems'
require 'sinatra'
require 'haml'
require 'yaml'
require 'dm-core'
require 'dm-timestamps'
require 'dm-validations'
require 'dm-migrations'
require 'rss/2.0'
require 'open-uri'
require "sinatra-authentication"

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

get '/feeds' do
  source = "http://www.facebook.com/feeds/page.php?id=201750899906651&format=rss20"
  descriptions = [] # raw content of rss feed will be loaded here
  content = ""
  open(source) do |s| content = s.read end
  rss = RSS::Parser.parse(content, false)
  rss.items.each {|o| descriptions << o.description}
  content = descriptions.collect do |o|
   # unless o.to_s =~ /img/m
  ('<div class="news">' + o.to_s + "</div>").gsub(/\<img(.*?)\>/m, "")

   # else
   #   ""
   # end
  end
end
