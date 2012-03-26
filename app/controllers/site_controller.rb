# -*- encoding : utf-8 -*-
class SiteController < ApplicationController
  def index
    @title = 'საწყისი'
  end

  def login
    @title = 'სისტემაში შესვლა'
    if request.post?
      user = Sys::User.authenticate(params[:email], params[:password])
      if user
        session[:user_id] = user.id
        redirect_to home_url
      else
        @error = 'არასწორი მომხმარებელი ან პაროლი'
      end
    end
  end

  def logout
    session[:user_id] = nil
    redirect_to home_url
  end

  def account
  end

end