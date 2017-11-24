require './config/environment'

class ApplicationController < Sinatra::Base
  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "secret"
    require 'sinatra/flash'
  end
  include ApplicationHelper 
  include Helpers

  register Sinatra::Flash

  get "/" do
    erb :index
  end

end

