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
end
