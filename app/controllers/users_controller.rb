class UsersController < ApplicationController
    
    get '/signup' do
        erb :'users/signup' 
    end 

    post '/signup' do
        #binding.pry 
        if !params[:name].empty? && !params[:email].empty? && !params[:password].empty? 
            @user = User.new(params)
            @user.save
            session[:id] = @user.id
            redirect '/meetups'
        else
            redirect '/signup'
        end 
    end

    get '/logout' do
        session.clear
        redirect '/'
    end
    
    get '/meetups' do
        #binding.pry 
        if session[:id]
            @user = Helpers.current_user(session)
            erb :'/meetups/index'
        else
            redirect :'/'
        end
    end 
end 