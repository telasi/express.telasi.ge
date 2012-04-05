# -*- encoding : utf-8 -*-
module Sys
  class Warehouse
    include Mongoid::Document
    include Mongoid::Timestamps
    field :name, type: String
    field :werks, type: String
    field :lgort, type: String

    validates_presence_of :werks
    validates_presence_of :lgort

    has_and_belongs_to_many :users, :class_name => 'Sys::User', dependent: :nullify

    index :name
    index [[:werks, Mongo::ASCENDING], [:lgort, Mongo::ASCENDING]]

    def sap_warehouse
      Sap::Warehouse.where(:mandt => Express::Sap::MANDT, :werks => self.werks, :lgort => self.lgort).first
    end

    # ეძებს საწყობებს მოცემული ტექსტის მიხედვით.
    def self.by_query(q)
      unless q.blank?
        array = q.split.map{ |w| { '$or' => [{:name => /#{w}/i}, {:lgort => /#{w}/i}, {:werks => /#{w}/i}]} }
        where('$and' => array)
      else
        where
      end
    end
  end
end
