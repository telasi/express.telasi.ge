# -*- encoding : utf-8 -*-
module Sys
  class Role
    include Mongoid::Document
    include Mongoid::Timestamps

    field :name, type: String
    field :description, type: String
    has_and_belongs_to_many :users, :class_name => 'Sys::User'

    validates_presence_of :name
    validates_uniqueness_of :name
  end
end
