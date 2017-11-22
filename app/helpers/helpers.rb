module Helpers

    def current_user #=> user instance || nil
        @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
    end

    def is_logged_in?
        !!current_user
    end
end