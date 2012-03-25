# -*- encoding : utf-8 -*-
module Sys
  class UsersController < ApplicationController
    def index
      @title = 'მომხმარებლები'
      @users = User.all(:order_by => :email)
    end
  end
end