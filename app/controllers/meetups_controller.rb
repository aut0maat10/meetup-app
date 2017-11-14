class MeetupsController < ApplicationController
    include ApplicationHelper
    
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
            flash[:success] = "Successfully created Meetup!"
            redirect "meetups/#{@meetup.id}"
        end
    end 

    ### SHOW MEETUP ###

    get '/my-meetups' do
        #binding.pry 
        @current_user = User.find(session[:id])
        @rsvp_arr = @current_user.rsvps.where(creator_id: @current_user.id)
        @meetups = @rsvp_arr.collect {|rsvp| rsvp.meetup}
        @my_rsvps = @current_user.rsvps.where(user_id: @current_user.id) 
        @my_meetups = @my_rsvps.collect {|rsvp| rsvp.meetup} - @meetups 
        #binding.pry
        erb :'/meetups/my_meetups'
    end 

    ### MEETUP BY ID ###
    get '/meetups/:id' do
        
        if Helpers.is_logged_in?(session)
            @meetup = Meetup.find(params[:id])
            rsvps = Rsvp.where(meetup_id: @meetup.id)
            @attendees = rsvps.collect {|rsvp| rsvp.user(user_id: rsvp.user_id)}
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
                flash[:success] = "You just joined this meetup!"
                redirect "/meetups/#{@meetup.id}"
            else
                flash[:notice] = "You already joined this meetup!"
                redirect "meetups/#{@meetup.id}"
            end 
        end
    end 

    ### EDIT MEETUP ### 

    get '/meetups/:id/edit' do
        @current_user = Helpers.current_user(session)
        @meetup = Meetup.find(params[:id])
        @rsvp = Rsvp.find_by(meetup_id: @meetup.id)
        @meetup_creator = User.find_by(id: @rsvp.creator_id)
        if @meetup_creator.id == @current_user.id
            erb :'/meetups/edit'
        else
            flash[:notice] = "You can only edit meetups you created!"
            redirect '/my-meetups'
        end 
    end 

    patch '/meetups/:id' do
         
        if params[:name].empty? || params[:description].empty? || params[:location].empty? || params[:time].empty?
            flash[:notice] = "Please fill in all fields!"
            redirect "/meetups/#{params[:id]}/edit"
        else
            @meetup = Meetup.find_by_id(params[:id])
            @meetup.name = params[:name]
            @meetup.description = params[:description]
            @meetup.location = params[:location]
            @meetup.time = params[:time]
            @meetup.save
            redirect "meetups/#{@meetup.id}"
            
        end
    end

    delete '/meetups/:id/delete' do
        
        @meetup = Meetup.find_by_id(params[:id])
        @meetup.delete
        Rsvp.where(meetup_id: @meetup.id).destroy_all
        flash[:success] = "Successfully deleted Meetup!"
        redirect '/my-meetups'
    end 

end