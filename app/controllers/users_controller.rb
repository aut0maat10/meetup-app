class UsersController < ApplicationController
    
    ### SIGNUP ###

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

    ### LOGIN ###

    get '/login' do
        if session[:id]
            redirect '/meetups'
        else
            erb :'users/login'
        end
    end  

    post '/login' do
        @user = User.find_by(name: params[:name])
        if @user && @user.authenticate(params[:password])
            session[:id] = @user[:id]
            redirect '/meetups'
        else
            redirect '/'
        end 
    end 

    ### LOGOUT ###

    get '/logout' do
        session.clear
        redirect '/'
    end

    ### MEETUPS INDEX ###
    
    get '/meetups' do
        if session[:id]
            @user = Helpers.current_user(session)
            erb :'/meetups/index'
        else
            redirect '/'
        end
    end 
end 