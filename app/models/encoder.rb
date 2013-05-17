require 'daud_coder'
module DaudDecodable
  
  def daud_decoded(*mnames)
    mnames.each do |m|
      mname = "#{m}="
      define_method(mname) do |v|
        super(DaudCoder.from_daud(v)) if v
      end
    end
  end
  
end