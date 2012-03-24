# -*- encoding : utf-8 -*-
include Sys

FactoryGirl.define do
  factory 'sys/user' do
    email      'dimitri@c12.ge'
    password   'secret'
    mobile     '595335514'
    first_name 'Dimitri'
    last_name  'Kurashvili'
  end
end
