# -*- encoding : utf-8 -*-
module Sys
  class UsersController < ApplicationController
    def index
      @title = 'მომხმარებლები'
      @users = User.all.order_by(:email)
    end

    def new
      @title = 'ახალი მომხმარებელი'
      if request.post?
        @user = Sys::User.new(params[:sys_user])
        redirect_to sys_users_url if @user.save
      else
        @user = Sys::User.new
      end
    end
  end
end