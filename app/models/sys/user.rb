# -*- encoding : utf-8 -*-

module Sys
  class User
    include Mongoid::Document
    include Mongoid::Timestamps
    field :email, type: String
    field :admin, type: Boolean
    field :salt, type: String
    field :hashed_password, type: String
    field :first_name, type: String
    field :last_name, type: String
    validates_presence_of :email
    validates_uniqueness_of :email
    validates_presence_of :first_name, :last_name
  end
end
