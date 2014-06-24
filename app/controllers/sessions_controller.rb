require 'auth.rb'

class SessionsController < ApplicationController
    skip_before_filter :check_for_user, :only => ['new', 'create']
    def new
        redirect_to :controller => 'home', :action => 'index' if current_user
    end


    def create
        unless params[:username]
                redirect_to new_session_path, :alert => 'Invalid username or password.'
                return
        end
        params[:username].downcase!
        ok = false
        user = User.where(:username => params[:username]).first
        if APP_CONFIG[:auth_ldap] && (!user || (user && user.password_hash == nil))
            lgi = ldap_login(params[:username], params[:password])
            if lgi && lgi.length > 0
                user = ldap_populate(params[:username], params[:password], user)
                session[:user_id] = user.id
                #flash[:notice] = "Logged in!"
                redirect_to (params[:return] ? params[:return] : root_path), :notice => 'Logged in!'
                ok = true
            else
                redirect_to new_session_path, :alert => 'Invalid username or password.'
                #flash[:alert] = "Invalid login."
            end
        elsif APP_CONFIG[:auth_local] && user && user.email != nil
            if user.password_hash == BCrypt::Engine.hash_secret(params[:password], user.password_salt)
                session[:user_id] = user.id
                #flash[:notice] = "Logged in!"
                redirect_to (params[:return] ? params[:return] : root_path), :notice => 'Logged in!'
            else
                #flash[:alert] = "Invalid local login."
                redirect_to new_session_path, :alert => 'Invalid username or password.'
            end
        else
            redirect_to new_session_path, :alert => 'Invalid login.'
        end

    end


    def destroy
        session[:user_id] = nil
        redirect_to root_url, :notice => "Logged out!"
    end
end
