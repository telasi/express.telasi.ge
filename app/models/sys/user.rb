# -*- encoding : utf-8 -*-
require 'c12-commons'

module Sys
  class User
    include Mongoid::Document
    include Mongoid::Timestamps
    field :email, type: String
    field :name, type: String
    field :mobile, type: String
    field :admin, type: Boolean
    field :salt, type: String
    field :hashed_password, type: String
    field :first_name, type: String
    field :last_name, type: String

    validates_presence_of :name, :email, :mobile
    validates_uniqueness_of :name, :email
    validates_presence_of :first_name, :last_name
    validate :mobile_format, :email_format
    validate :password_presence

    has_and_belongs_to_many :warehouses, :class_name => 'Sys::Warehouse', dependent: :nullify

    index :email, :unique => true
    index :name, :unique => true
    index :first_name
    index :last_name

    before_create :user_before_create

    def self.authenticate(email, pwd)
      user = User.where(:email => email).first
      user if user and user.hashed_password == Digest::SHA1.hexdigest("#{pwd}dimitri#{user.salt}")
    end

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

    def full_name
      "#{self.first_name} #{self.last_name}"
    end

    private

    def mobile_format
      if self.mobile and not C12.correct_mobile?(self.mobile)
        errors.add(:mobile, 'არასწორი მობილური') 
      end
    end

    def email_format
      if self.email and not C12.correct_email?(self.email)
        errors.add(:email, 'არასწორი ელ. ფოსტა')
      end
    end

    def password_presence
      if self.hashed_password.nil? and self.password.nil?
        errors.add(:password, 'ჩაწერეთ პაროლი')
      end
    end

    def user_before_create
      first = User.count == 0
      self.admin = first
      self.mobile = C12.compact_mobile(self.mobile)
    end
  end
end
