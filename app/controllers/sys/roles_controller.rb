# -*- encoding : utf-8 -*-
module Sys
  class RolesController < SysController
    def index
      @title = 'როლები'
      @roles = Role.all.asc(:name)
    end

    def new
      @title = 'ახალი როლი'
      if request.post?
        @role = Sys::Role.new(params[:sys_role])
        redirect_to sys_roles_url, :notice => 'როლი შექმნილია.' if @role.save
      else
        @role = Sys::Role.new
      end
    end

    def edit
      @title = 'როლის რედაქტირება'
      @role = Role.find(params[:id])
      if request.put?
        redirect_to sys_show_role_url(@role), :notice => 'როლი განახლებულია.' if @role.update_attributes(params[:sys_role])
      end
    end

    def show
      @role = Role.find(params[:id])
      @title = @role.name
    end

    def delete
      @role = Role.find(params[:id])
      @role.destroy
      redirect_to sys_roles_url, :notice => 'როლი წაშლილია.'
    end
  end
end