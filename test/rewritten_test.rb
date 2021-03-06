require 'test_helper'

describe Rewritten do

  before{
    Rewritten.add_translation('/from', '/to')
    Rewritten.add_translation('/from2', '/to')
    Rewritten.add_translation('/from3', '/to2')

    #with flags
    Rewritten.add_translation('/with/flags  [L12]', '/to3')
  }

  describe "basic interface" do

    it "must translate froms" do
      Rewritten.translate('/from').must_equal '/to'
      Rewritten.translate('/from2').must_equal '/to'
      Rewritten.translate('/from3').must_equal '/to2'
      Rewritten.translate('/with/flags').must_equal '/to3'
    end

    it "must give current_translation" do
      Rewritten.get_current_translation('/to').must_equal '/from2'
      Rewritten.get_current_translation('/to2').must_equal '/from3'
      Rewritten.get_current_translation('/to3').must_equal '/with/flags'
      Rewritten.get_current_translation('/n/a').must_equal '/n/a'
    end

    it "must return the  complete line with flags" do
      Rewritten.full_line('/from').must_equal '/from'
      Rewritten.full_line('/with/flags').must_equal '/with/flags [L12]'
    end

    it "must give all tos" do
      Rewritten.all_tos.sort.must_equal ["/to", "/to2", "/to3"] 
    end

  end


  describe "flag management" do

    it "must return a flag string" do
      Rewritten.get_flag_string('/with/flags').must_equal "L12"
      Rewritten.get_flag_string('/n/a').must_equal ""
    end

    it "must query flags" do
      Rewritten.has_flag?('/with/flags', 'X').must_equal false
      Rewritten.has_flag?('/with/flags', 'L').must_equal true
      Rewritten.has_flag?('/with/flags', '1').must_equal true
      Rewritten.has_flag?('/with/flags', '2').must_equal true
    end

  end

end


