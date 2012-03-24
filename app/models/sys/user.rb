# -*- encoding : utf-8 -*-

module Sys
  class User
    include Mongoid::Document
    include Mongoid::Timestamps
    field :email, type: String
    field :mobile, type: String
    field :admin, type: Boolean
    field :salt, type: String
    field :hashed_password, type: String
    field :first_name, type: String
    field :last_name, type: String

    validates_presence_of :email, :mobile
    validates_uniqueness_of :email
    validates_presence_of :first_name, :last_name

    index :email
    index :first_name
    index :last_name
    
    before_create :user_before_create

    def password
      @password
    end

    def password=(pwd)
      @password = pwd
      unless pwd.nil? or pwd.strip.empty?
        self.salt = "salt#{rand 100}#{Time.now}"
        self.hashed_password = Digest::SHA1.hexdigest("#{pwd}dimitri#{salt}")
      end
    end

    private

    def user_before_create
      first = User.count == 0
      self.admin = first
      self.mobile = Sys.compact_mobile(self.mobile)
    end

  end
end
