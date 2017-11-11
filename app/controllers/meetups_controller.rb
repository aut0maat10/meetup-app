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
        if params[:name].empty? || params[:description].empty? || params[:location].empty? || params[:time].empty?
            flash[:notice] = "Please fill in all fields!"
            redirect '/meetups/create'
        else
            @current_user = User.find(session[:id])
            @meetup = Meetup.create(params)
            Rsvp.create(user_id: @current_user.id, meetup_id: @meetup.id, creator_id: @current_user.id)
            redirect "meetups/#{@meetup.id}"
        end
    end 

    ### SHOW MEETUP ###

    get '/my-meetups' do
        @current_user = User.find(session[:id])
        @rsvp_arr = @current_user.rsvps.where(creator_id: @current_user.id)
        @meetups = @rsvp_arr.collect {|rsvp| rsvp.meetup}
        @my_rsvps = @current_user.rsvps.where(user_id: @current_user.id) 
        @my_meetups = @my_rsvps.collect {|rsvp| rsvp.meetup} - @meetups 
        #binding.pry
        erb :'/meetups/my_meetups'
    end 

    get '/meetups/:id' do
        #binding.pry
        if Helpers.is_logged_in?(session)
            @meetup = Meetup.find(params[:id])
            erb :'/meetups/show'
        else
            flash[:notice] = "You have to be logged in to do that!"
            redirect '/login'
        end
    end

    post '/meetups/:id' do
        #binding.pry
        if Helpers.is_logged_in?(session) # => true 
            @current_user = User.find(session[:id]) # => leif
            @meetup = Meetup.find(params[:id])
            if Rsvp.exists?(user_id: @current_user.id, meetup_id: @meetup.id) == false
                Rsvp.create(user_id: @current_user.id, meetup_id: @meetup.id)
                flash[:notice] = "You just joined this meetup!"
                redirect "/meetups/#{@meetup.id}"
            else
                flash[:notice] = "You already joined this meetup!"
                redirect '/meetups'
            end 
        end
    end 

    get '/meetups/:id/edit' do
    end 

end