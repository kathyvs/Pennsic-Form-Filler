require 'spec_helper' 
require 'pdf_forms'

describe PDFForms do

  before(:each) do 
    @fields = mock("fields")
    @reader = mock("reader", :acro_fields => @fields)
  end

  describe "select lists" do
    
    it "returns the list of valid values on collection" do
      pdf = PDFForms::PDFForm.new(@reader)
      vals = ["One", "Two", "Three", "Off"];
      @fields.should_receive(:get_appearance_states)\
             .with('Resub')\
             .and_return(vals)
      result = pdf.collection(:resub_from)
      result.should eq(["One", "Two", "Three", "---"])
    end
  end
end

