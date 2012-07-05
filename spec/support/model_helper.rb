
module ModelHelper
  
  Spec::Matchers.define :be_new do 
    match do |model|
      not(model.id or model.persisted?)
    end
  end
  
  Spec::Matchers.define :have_error do
    match do |model|
      model.errors.contains
    end
  end

end