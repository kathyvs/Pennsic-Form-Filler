# Load the rails application
require File.expand_path('../application', __FILE__)

jar_dir = File.expand_path('../../lib/java', __FILE__)
Dir.glob("#{jar_dir}/*.jar") do |f|
  $CLASSPATH << "file://#{f}"
end

#Add mime type
Mime::Type.register("application/pdf", :pdf)

# Initialize the rails application
FormFiller::Application.initialize!
