# -*- encoding : utf-8 -*-
ENV['TZ'] = 'UTC'

#ActiveSupport.on_load(:active_record) do
#
#  ActiveRecord::ConnectionAdapters::OracleEnhancedAdapter.class_eval do
#    # true and false will be stored as 'Y' and 'N'
#    self.emulate_booleans_from_strings = true
#    # start primary key sequences from 1 and take just one next value in each session
#    self.default_sequence_start_value = "1 NOCACHE INCREMENT BY 1"
#  end
#
#end

Sap::Base.establish_connection :sap
