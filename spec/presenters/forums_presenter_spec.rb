require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ForumsPresenter do
  before(:each) do
    @current_user = Generate.user
    Forum.stub!(:ordered).and_return([1,2,3])
    @forums_presenter = ForumsPresenter.new(:current_user => @current_user, :forums => Forum.ordered)
  end
  
  it "should properly determine if a user can create a new forum" do
    @forums_presenter.can_be_created_by_current_user?.should eql(false)
    @forums_presenter.instance_variable_set(:@current_user, Generate.admin_user)
    @forums_presenter.can_be_created_by_current_user?.should eql(true)
    @forums_presenter.instance_variable_set(:@current_user, nil)
    @forums_presenter.can_be_created_by_current_user?.should eql(false)
  end
  
  it "should pass the block enumerator to @forums#each" do
    @forums_presenter.map {|i| i}.should eql([1,2,3])
  end
end
