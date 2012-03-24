# -*- encoding : utf-8 -*-

module Sys
  def self.correct_email?(email)
    not not (email =~ /^\S+@\S+$/)
  end
end
