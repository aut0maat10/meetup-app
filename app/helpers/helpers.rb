module Helpers

    def current_user #=> user instance || nil
        @current_user ||= User.find_by(id: session[:id]) if session[:id]
    end

    def is_logged_in?
        !!current_user
    end
end