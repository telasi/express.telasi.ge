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
    @title = 'ანგარიშის მართვა'
    @user = current_user
    if request.put?
      redirect_to home_url, :notice => 'თქვენი მონაცემები განახლებულია' if @user.update_attributes(params[:sys_user])
    end
  end

  def password
    @title = 'ანგარიშის მართვა'
    @user = current_user
    if request.put?
      redirect_to home_url, :notice => 'თქვენი პაროლი შეცვლილია' if @user.update_attributes(params[:sys_user])
    end
  end
end
