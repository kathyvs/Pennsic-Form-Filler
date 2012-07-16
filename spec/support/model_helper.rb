
module ModelHelper
  
  Spec::Matchers.define :be_new do 
    match do |model|
      not(model.id or model.persisted?)
    end
  end
  
  Spec::Matchers.define :have_error do
    match do |model|
      puts model.errors.inspect
      puts model.errors.contains.inspect
      model.errors.contains
    end
  end

end