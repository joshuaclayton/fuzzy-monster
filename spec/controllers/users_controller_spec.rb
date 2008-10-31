require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe UsersController do
  
  def post_login
    @user = Generate.user(:password => "password", :password_confirmation => "password")
    post :login, :user => {:email_address => @user.email_address, :password => "password"}
  end
  
  it "should be able to log in" do
    post_login
    response.should redirect_to(root_url)
  end
end
