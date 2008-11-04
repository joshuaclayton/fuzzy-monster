require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe TopicPresenter do
  before(:each) do
    @current_user = Generate.user
    @topic = Generate.topic(:title => "Test Topic", :creator => @current_user)
    @topic_presenter = TopicPresenter.new(:current_user => @current_user, :topic => @topic)
  end
  
  it "should allow the creator to edit" do
    @topic.creator.should_receive(:==).with(@current_user).and_return(true)
    @topic_presenter.can_be_edited_by_current_user?.should eql(true)
  end
  
  it "should not allow any non-creator to edit" do
    @current_user = Generate.admin_user
    @topic.creator.should_receive(:==).with(@current_user).and_return(false)
    @topic_presenter.instance_variable_set(:@current_user, @current_user)
    @topic_presenter.can_be_edited_by_current_user?.should eql(false)
  end
  
  it "should properly check if user can lock or sticky the topic" do
    @topic_presenter.should_receive(:is_current_user_admin?).twice.and_return(false)
    @topic_presenter.can_be_locked_by_current_user?.should eql(false)
    @topic_presenter.can_be_stickied_by_current_user?.should eql(false)
  end
  
  it "should allow admins to sticky and lock" do
    @current_user = Generate.admin_user
    @topic_presenter.instance_variable_set(:@current_user, @current_user)
    @topic_presenter.should_receive(:is_current_user_admin?).twice.and_return(true)
    @topic_presenter.can_be_locked_by_current_user?.should eql(true)
    @topic_presenter.can_be_stickied_by_current_user?.should eql(true)
  end
  
  it "should be able to check if current user is an admin" do
    @topic_presenter.instance_variable_get(:@current_user).should_receive(:has_privilege?).with(:admin).and_return(false)
    @topic_presenter.send(:is_current_user_admin?).should eql(false)
  end
  
  it "should use method_missing for misc. methods" do
    @topic.should_receive(:title).once.and_return("Test Topic")
    @topic_presenter.title.should eql("Test Topic")
  end
end
