# -*- encoding : utf-8 -*-

module Sys

  # მობილურის "კომპაქტიზაცია": ტოვებს მხოლოდ ციფრებს.
  def self.compact_mobile(mob)
    mob.scan(/[0-9]/).join('') if mob
  end

  # ამოწმებს მობილურის ნომრის კორექტულობას.
  # კორექტული მობილურის ნომერი უნდა შეიცავდეს 9 ციფრს.
  def self.correct_mobile?(mob)
    not not (compact_mobile(mob) =~ /^[0-9]{9}$/)
  end

end