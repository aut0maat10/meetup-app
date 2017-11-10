class MeetupsController < ApplicationController

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