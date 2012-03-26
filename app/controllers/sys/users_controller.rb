# -*- encoding : utf-8 -*-
module Sys
  class UsersController < SysController
    def index
      @title = 'მომხმარებლები'
      @users = User.all.order_by(:email)
    end

    def new
      @title = 'ახალი მომხმარებელი'
      if request.post?
        @user = Sys::User.new(params[:sys_user])
        redirect_to sys_users_url, :notice => 'მომხმარებელი შექმნილია.' if @user.save
      else
        @user = Sys::User.new
      end
    end

    def edit
      @title = 'მომხმარებლის რედაქტირება'
      @user = User.find(params[:id])
      if request.put?
        redirect_to sys_show_user_url(@user), :notice => 'მომხმარებელი განახლებულია.' if @user.update_attributes(params[:sys_user])
      end
    end

    def show
      @user = Sys::User.find(params[:id])
      @title = @user.full_name
    end

    def delete
      @user = Sys::User.find(params[:id])
      @user.destroy
      redirect_to sys_users_url, :notice => 'მომხმარებელი წაშლილია'
    end
  end
end