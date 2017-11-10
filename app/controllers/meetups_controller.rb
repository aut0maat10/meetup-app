class MeetupsController < ApplicationController

    ### MEETUPS INDEX ###
    
    get '/meetups' do
        @meetups = Meetup.all 
        if session[:id]
            @user = Helpers.current_user(session)
            erb :'/meetups/index'
        else
            redirect '/'
        end
    end 

    ### CREATE MEETUP ###

    get '/meetups/create' do
        if Helpers.is_logged_in?(session) 
            erb :'/meetups/create'
        else
            redirect '/login'
        end 
    end
    
    post '/meetups' do
        if params[:name].empty? || params[:description].empty? || params[:location].empty?
            flash[:notice] = "Please fill in all fields!"
            redirect '/meetups/create'
        else
            @current_user = User.find_by(session[:id])
            binding.pry
            @meetup = Meetup.create(params)
            Rsvp.create(user_id: @current_user.id, meetup_id: @meetup.id)
        end
    end 

    ### SHOW MEETUP ###

    get '/meetups/:id' do
        if Helpers.is_logged_in?(session)
            @meetup = Meetup.find(params[:id])
            erb :'/meetups/show'
        else
            flash[:notice] = "You have to be logged in to do that!"
            redirect '/login'
        end
    end

end