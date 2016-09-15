require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'

# админка 1/1
configure do
  enable :sessions
end

helpers do
  def username
    session[:identity] ? session[:identity] : 'Вход с паролем'
  end
end

before '/secure/*' do
  unless session[:identity]
    session[:previous_url] = request.path
    @error = 'Вам необходимо войти для доступа к ' + request.path
    halt erb(:login_form)
  end
end
# админка 1/1

set :database, "sqlite3:base.db"

class Client < ActiveRecord::Base
	validates :name, presence: true, length: { minimum: 2 }
	validates :phone, presence: true, length: { minimum: 6 }
	validates :datestamp, presence: true
	validates :message, presence: true
	validates :name, presence: true
end

class Option < ActiveRecord::Base
end

before do
	@options = Option.all
end

get '/' do
	erb :index			
end

# админка 2/2
get '/login/form' do
  erb :login_form
end

post '/login/attempt' do
	@username = params[:username]
	@pass = params[:pass]

	if @pass == 'love'
		  session[:identity] = params['username']
		  where_user_came_from = session[:previous_url] || '/'
		  redirect to where_user_came_from
	else
		@error = 'Доступ запрещен'
		return erb :login_form
	end

end

get '/logout' do
  session.delete(:identity)
  erb "<div class='alert alert-message'>Вы вышли</div>"
end

get '/secure/place' do
	@list = Client.order('created_at DESC')
	erb :clientlist
end
# админка 2/2

get '/about' do
  erb 'Здесь будет информация о нашей деятельности.'
end

get '/contacts' do
	erb :contacts
end

get '/category' do
	erb :categorys
end

get '/visit' do
	@c = Client.new
	erb :visit
end

post '/visit' do

	@c = Client.new params[:client]
	if @c.save
		erb "<h3>Благодарим вас, <%= @c.name %>. Ваше письмо отправлено!</h3>"
	else
		# @error = @c.errors.full_messages.first
		@error = 'Пожалуйста, заполните все поля'
		erb :visit
	end
end

get '/category/:id' do
	@category = Option.find(params[:id])
	erb :category
end

get '/secure/client-:id' do
	@list = Client.find(params[:id])
	erb :client
end