module ApplicationHelper
def current_user  
    if session[:user_id]
		current_user ||= User.find(session[:user_id])
		if(session[:override])
			@override = true
			current_user.privilege = session[:override]
		else
			@override = false
		end
		current_user
	else
		current_user = nil
		nil
	end
  end

end
