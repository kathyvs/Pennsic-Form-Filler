require 'decode_map'

describe DecodeMap do
  describe 'when decorating a map-like object' do
    it 'converts strings' do
      s = '{AE}thelmearc'
      m = {:a => s}
      m.extend(DecodeMap)
      m[:a].should eq(DaudCoder.from_daud(s))
    end
    
    it 'decorates maps' do
      s = 'Mendo{c,}a'
      m = {:a => {:b => s}}
      m.extend(DecodeMap)
      m[:a].should be_kind_of(DecodeMap)
      m[:a][:b].should eq(DaudCoder.from_daud(s))      
    end
    
    it "does not decorate strings" do
      m = {:a => 'abc'}
      m.extend(DecodeMap)
      m[:a].should_not be_kind_of(DecodeMap)
    end
    
    it 'decorates other map-like objects' do
      m = {:a => [1, 2, 3]}
      m.extend(DecodeMap)
      m[:a].should be_kind_of(DecodeMap)
    end

    it 'leaves non-map-like values alone' do
      m = {:a => :b}
      m.extend(DecodeMap)
      m[:a].should_not be_kind_of(DecodeMap)
    end
    
    it 'leaves numbers alone' do
      m = {:a => 3}
      m.extend(DecodeMap)
      m[:a].should_not be_kind_of(DecodeMap)
    end
    
    it "applies encoding to each as well" do
      m = {:a => 1, :b => 'Do{n~}a'}
      m.extend(DecodeMap)
      s = {:a => m[:a], :b => m[:b]}
      m.each do |k, v|
        v.should eq(s[k])
      end
    end
  end
end