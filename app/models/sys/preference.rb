# -*- encoding : utf-8 -*-
module Sys
  class Preference
    include Mongoid::Document

    field :user_id, type: String
    field :key, type: String
    field :value, type: String

    index [[:user_id, Mongo::ASCENDING], [:key, Mongo::ASCENDING]]

    def self.get(user, key)
      if user
        pref = Preference.where(:user_id => user.id, :key => key).first
        pref.value if pref
      end
    end

    def self.set(user, key, val)
      if user
        pref = Preference.where(:user_id => user.id, :key => key).first
        pref = Preference.new(:user_id => user.id, :key => key) unless pref
        pref.value = val
        pref.save
      end
    end
  end
end
