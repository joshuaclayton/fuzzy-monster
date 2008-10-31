require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ForumPresenter do
  before(:each) do
    @current_user = Generate.user
    @forum = Generate.forum(:name => "Test Forum")
    @forum_presenter = ForumPresenter.new(:current_user => @current_user, :forum => @forum)
  end
  
  it "should know if current user can edit" do
    @forum_presenter.can_be_edited_by_current_user?.should eql(false)
    @forum_presenter.instance_variable_set(:@current_user, Generate.admin_user)
    @forum_presenter.can_be_edited_by_current_user?.should eql(true)
    @forum_presenter.instance_variable_set(:@current_user, nil)
    @forum_presenter.can_be_edited_by_current_user?.should eql(false)
  end
  
  it "should know if current user can delete" do
    @forum_presenter.can_be_deleted_by_current_user?.should eql(false)
    @forum_presenter.instance_variable_set(:@current_user, Generate.admin_user)
    @forum_presenter.can_be_deleted_by_current_user?.should eql(false)
    @forum_presenter.instance_variable_set(:@current_user, nil)
    @forum_presenter.can_be_deleted_by_current_user?.should eql(false)
  end
  
  it "should delegate with method_missing to forum" do
    @forum_presenter.instance_variable_get(:@forum).should_receive(:name).and_return("Test Forum")
    @forum_presenter.name.should eql("Test Forum")
  end
end
