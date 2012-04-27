# -*- encoding : utf-8 -*-
module Telasi::Queryable
  module ClassMethods

    def search_by_q(q, *fields)
      unless q.blank?
        ary = q.split.map{ |w| { '$or' => fields.map {|f| {f => /#{Regexp::escape(w)}/i} } } }
        where('$and' => ary)
      else
        where
      end
    end

  end

  def self.included(base)
    base.extend(ClassMethods)
  end

end
