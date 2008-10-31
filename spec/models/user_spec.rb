require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe User do
  before(:each) do
    @user = Generate.user(:first_name => "John", :last_name => "Doe")
  end
  
  it "should know it's full name" do
    @user.full_name.should eql("John Doe")
    @user.username = "username"
    @user.first_name = nil
    @user.last_name = nil
    @user.full_name.should eql(@user.username)
  end
end
