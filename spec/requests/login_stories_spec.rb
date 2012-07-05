require 'spec_helper'

describe "LoginStories" do
  urls = ["/accounts", "/events"]
  
  urls.each do |url|
    describe "GET #{url}" do
      it "requests authentication" do
        get url
        puts(self.methods.sort)
        response.status.should be(401)
      end
    end
  end
end
