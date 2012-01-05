require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ForumPresenter do

  before(:each) do
    @current_user = Generate.user
    @forum = Generate.forum(:name => "Test Forum")
    @forum_presenter = ForumPresenter.new(:current_user => @current_user, :forum => @forum)
  end 

  context 'an admin user' do
    before(:each) do
      @forum_presenter.instance_variable_set(:@current_user, Generate.admin_user)
    end 
    
    it "should know that the admin user can edit" do
      @forum_presenter.can_be_edited_by_current_user?.should eql(true)
    end 
    
    it "should know that an admin user can delete" do 
      @forum_presenter.can_be_deleted_by_current_user?.should eql(false)    
    end 
    
    it "should know that an admin user can create a new topic" do
      @forum_presenter.can_topic_be_created_by_current_user?.should eql(true)    
    end 
  end 
  
  context 'a non-admin user' do
    it "should know that the user cannot edit" do
      @forum_presenter.can_be_edited_by_current_user?.should eql(false)   
    end
    
    it "should know that the user cannot delete" do
      @forum_presenter.can_be_deleted_by_current_user?.should eql(false)    
    end 
    
    it "should know that the user can create a new topic" do
      @forum_presenter.can_topic_be_created_by_current_user?.should eql(true)    
    end 
  end 
  
  context 'no user' do
    before(:each) do
      @forum_presenter.instance_variable_set(:@current_user, nil)
    end 
    
    it "should know the forum cannot be edited without a current user" do
      @forum_presenter.can_be_edited_by_current_user?.should eql(false)    
    end 
    
    it "should know that a forum cannot be deleted without a user" do
      @forum_presenter.can_be_deleted_by_current_user?.should eql(false)    
    end
    
    it "should know that a forum cannot be created without a user" do
      @forum_presenter.can_topic_be_created_by_current_user?.should eql(false)    
    end    
  end 

  it "should delegate with method_missing to forum" do
    @forum_presenter.instance_variable_get(:@forum).should_receive(:name).and_return("Test Forum")
    @forum_presenter.name.should eql("Test Forum")
  end
end
