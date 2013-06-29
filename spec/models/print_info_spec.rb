require 'spec_helper'

describe PrintInfo do
  
  describe "when initialized from config" do
    
    before :each do
      @config = Rails::Application::Configuration.new
    end
    
    it "The printers are taken from the 'printers' variable" do
      @config.printers = {'a' => 'b', 'c' => 'd'}
      info = PrintInfo.from_config(@config)
      info.printer_pairs.should eq([['a', 'b'], ['c', 'd']])
    end
    
  end
  describe "when given a singleton printer mapping" do
    before :each do
      @info = PrintInfo.new(printers = {'a' => 'b'})
    end
 
    it "indicates that it has printers" do
      @info.should have_printers
    end
    
    it "indicates that it has a single printer" do
      @info.should have_singleton_printer
    end
  end
  
  describe "when given an empty printer mapping" do
    before :each do
      @info = PrintInfo.new
    end
    
    it "inicates that it has no printers" do
      @info.should_not have_printers
    end

    it "indicates that it does not have a single printer" do
      @info.should_not have_singleton_printer
    end
  end
  
  describe "when given a multiple printer mapping" do
 
    before :each do
      @info = PrintInfo.new(printers = {'key1' => 'name1', 'key4' => 'name4', 
        'key3' => 'name3', 'key2' => 'name2'})
    end

    it "indicates that it has printers" do
      @info.should have_printers
    end
    
    it "returns a sorted pair of the printers when getting printers" do
      @info.printer_pairs.should eq([['key1', 'name1'], ['key2', 'name2'], 
                                    ['key3', 'name3'], ['key4', 'name4']])
    end
    
    it "indicates that it does not have a single printer" do
      @info.should_not have_singleton_printer
    end
    
  end
end