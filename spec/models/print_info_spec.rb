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
    
    it "The shell command is taken fromthe 'print_comment' variable" do
      @config.print_command = "test #%copies"
      info = PrintInfo.from_config(@config)
      info.shell_pattern.should eq(@config.print_command)
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
  
  describe "method print" do
    module FakeSystem
      attr_accessor :shell_command, :data
      def run_system(cmd, data)
        @shell_command = cmd
        @data = data
      end
    end
    
    def build_info(shell) 
      info = PrintInfo.new(printers = {'a' => 'b'}, shell_pattern = shell)
      info.extend FakeSystem
      return info
    end
     
    it " given printer and copies and form, places them in the shell pattern " do
      shell_pattern = 'Printer = #%{printer}, Copies = #%{copies}, Filename = #%{file_name}'
      printer = 'test_printer'
      copies = 5
      data = "abcde"
      file_name = "test.pdf"
      expected = shell_pattern % {:printer => printer, :copies => copies, :file_name => file_name}
      form = mock_model(Form, :pdf_data => data, :file_name => file_name).as_null_object
      info = build_info(shell_pattern)
      info.print(form, printer = printer, copies = copies)
      info.shell_command.should eq(expected)
      info.data.should eq(data)
    end
  end
end