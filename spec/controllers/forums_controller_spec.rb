require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ForumsController do

  def mock_forum(stubs={})
    @mock_forum ||= mock_model(Forum, stubs)
  end
  
  
  describe "responding to GET index" do
    before :each do
      @forums = mock("ForumsPresenter", :forums => [1,2,3])
      ForumsPresenter.stub!(:new).and_return(@forums)
    end
    
    it "should expose all forums as @forums" do
      Forum.should_receive(:ordered).and_return([mock_forum])
      get :index
      assigns[:forums].should == @forums
    end

    describe "with mime type of xml" do
  
      it "should render all forums as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        Forum.should_receive(:ordered).and_return(forums = @forums)
        forums.should_receive(:to_xml).and_return("generated XML")
        get :index
        response.body.should == "generated XML"
      end
    
    end

  end

  describe "responding to GET show" do
    before :each do
      @forum = mock("ForumPresenter")
      ForumPresenter.stub!(:new).and_return(@forum)
      Forum.stub!(:find_by_slug!).and_return(@forum)
    end
    
    it "should expose the requested forum as @forum" do
      # Forum.should_receive(:find_by_slug!).with("37").and_return(mock_forum)
      get :show, :id => "37"
      assigns[:forum].should equal(@forum)
    end
    
    describe "with mime type of xml" do

      it "should render the requested forum as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        # Forum.should_receive(:find_by_slug!).with("37").and_return(mock_forum)
        @forum.should_receive(:to_xml).and_return("generated XML")
        get :show, :id => "37"
        response.body.should == "generated XML"
      end

    end
    
  end

  describe "responding to GET new" do
    before :each do
      login_with(:admin)
      @forum = mock("ForumPresenter")
      ForumPresenter.stub!(:new).and_return(@forum)
      Forum.stub!(:find_by_slug!).and_return(@forum)
    end
    
    it "should expose a new forum as @forum" do
      get :new
      assigns[:forum].should eql(@forum)
    end

  end

  describe "responding to GET edit" do
    before :each do
      login_with(:admin)
      @forum = mock("ForumPresenter", :can_be_edited_by_current_user? => true)
      ForumPresenter.stub!(:new).and_return(@forum)
      Forum.stub!(:find_by_slug!).and_return(@forum)
    end
    
    it "should expose the requested forum as @forum" do
      get :edit, :id => "37"
      assigns[:forum].should equal(@forum)
    end

  end

  describe "responding to POST create" do
    
    before :each do
      login_with(:admin)
      @forum = mock("ForumPresenter", :save => true)
      ForumPresenter.stub!(:new).and_return(@forum)
      Forum.stub!(:new).and_return(@forum)
    end
    
    describe "with valid params" do
      
      it "should expose a newly created forum as @forum" do
        Forum.should_receive(:new).with({'these' => 'params'}).and_return(@forum)
        post :create, :forum => {:these => 'params'}
        assigns(:forum).should equal(@forum)
      end

      it "should redirect to the created forum" do
        Forum.stub!(:new).and_return(mock_forum(:save => true))
        post :create, :forum => {}
        response.should redirect_to(forum_url(@forum))
      end
      
    end
    
    describe "with invalid params" do

      it "should expose a newly created but unsaved forum as @forum" do
        @forum.stub!(:save).and_return(false)
        Forum.stub!(:new).with({'these' => 'params'}).and_return(@forum)
        post :create, :forum => {:these => 'params'}
        assigns(:forum).should equal(@forum)
      end

      it "should re-render the 'new' template" do
        @forum.stub!(:save).and_return(false)
        Forum.stub!(:new).and_return(@forum)
        post :create, :forum => {}
        response.should render_template('new')
      end
      
    end
    
  end

  describe "responding to PUT udpate" do

    describe "with valid params" do
      
      before :each do
        login_with(:admin)
        @forum = mock("ForumPresenter", :can_be_edited_by_current_user? => true, :update_attributes => true)
        ForumPresenter.stub!(:new).and_return(@forum)
        Forum.stub!(:find_by_slug!).and_return(@forum)
      end
      
      it "should update the requested forum" do
        Forum.should_receive(:find_by_slug!).with("37").and_return(@forum)
        @forum.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :forum => {:these => 'params'}
      end

      it "should expose the requested forum as @forum" do
        put :update, :id => "1"
        assigns(:forum).should equal(@forum)
      end

      it "should redirect to the forum" do
        put :update, :id => "1"
        response.should redirect_to(forum_url(@forum))
      end

    end
    
    describe "with invalid params" do
      before :each do
        login_with(:admin)
        @forum = mock("ForumPresenter", :can_be_edited_by_current_user? => true, :update_attributes => false)
        ForumPresenter.stub!(:new).and_return(@forum)
        Forum.stub!(:find_by_slug!).and_return(@forum)
      end
      
      it "should update the requested forum" do
        Forum.should_receive(:find_by_slug!).with("37").and_return(@forum)
        @forum.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :forum => {:these => 'params'}
      end

      it "should expose the forum as @forum" do
        Forum.stub!(:find_by_slug!).and_return(@forum)
        put :update, :id => "1"
        assigns(:forum).should equal(@forum)
      end

      it "should re-render the 'edit' template" do
        Forum.stub!(:find_by_slug!).and_return(@forum)
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end
  end

  describe "responding to DELETE destroy" do
    before :each do
      login_with(:admin)
    end
    
    it "should redirect to the forums list" do
      Forum.stub!(:find_by_slug!).and_return(mock_forum(:destroy => false))
      delete :destroy, :id => "1"
      response.response_code.should == 401
    end
  end
end
