
module ModelHelper
  
  Spec::Matchers.define :be_new do 
    match do |model|
      not(model.id or model.persisted?)
    end
  end

end