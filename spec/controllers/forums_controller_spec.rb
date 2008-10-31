require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ForumsController do

  def mock_forum(stubs={})
    @mock_forum ||= mock_model(Forum, stubs)
  end
  
  describe "responding to GET index" do

    it "should expose all forums as @forums" do
      Forum.should_receive(:ordered).and_return([mock_forum])
      get :index
      assigns[:forums].should == [mock_forum]
    end

    describe "with mime type of xml" do
  
      it "should render all forums as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        Forum.should_receive(:ordered).and_return(forums = mock("Array of Forums"))
        forums.should_receive(:to_xml).and_return("generated XML")
        get :index
        response.body.should == "generated XML"
      end
    
    end

  end

  describe "responding to GET show" do

    it "should expose the requested forum as @forum" do
      Forum.should_receive(:find_by_slug!).with("37").and_return(mock_forum)
      get :show, :id => "37"
      assigns[:forum].should equal(mock_forum)
    end
    
    describe "with mime type of xml" do

      it "should render the requested forum as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        Forum.should_receive(:find_by_slug!).with("37").and_return(mock_forum)
        mock_forum.should_receive(:to_xml).and_return("generated XML")
        get :show, :id => "37"
        response.body.should == "generated XML"
      end

    end
    
  end

  describe "responding to GET new" do
  
    it "should expose a new forum as @forum" do
      Forum.should_receive(:new).and_return(mock_forum)
      get :new
      assigns[:forum].should equal(mock_forum)
    end

  end

  describe "responding to GET edit" do
  
    it "should expose the requested forum as @forum" do
      Forum.should_receive(:find_by_slug!).with("37").and_return(mock_forum)
      get :edit, :id => "37"
      assigns[:forum].should equal(mock_forum)
    end

  end

  describe "responding to POST create" do

    describe "with valid params" do
      
      it "should expose a newly created forum as @forum" do
        Forum.should_receive(:new).with({'these' => 'params'}).and_return(mock_forum(:save => true))
        post :create, :forum => {:these => 'params'}
        assigns(:forum).should equal(mock_forum)
      end

      it "should redirect to the created forum" do
        Forum.stub!(:new).and_return(mock_forum(:save => true))
        post :create, :forum => {}
        response.should redirect_to(forum_url(mock_forum))
      end
      
    end
    
    describe "with invalid params" do

      it "should expose a newly created but unsaved forum as @forum" do
        Forum.stub!(:new).with({'these' => 'params'}).and_return(mock_forum(:save => false))
        post :create, :forum => {:these => 'params'}
        assigns(:forum).should equal(mock_forum)
      end

      it "should re-render the 'new' template" do
        Forum.stub!(:new).and_return(mock_forum(:save => false))
        post :create, :forum => {}
        response.should render_template('new')
      end
      
    end
    
  end

  describe "responding to PUT udpate" do

    describe "with valid params" do

      it "should update the requested forum" do
        Forum.should_receive(:find_by_slug!).with("37").and_return(mock_forum)
        mock_forum.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :forum => {:these => 'params'}
      end

      it "should expose the requested forum as @forum" do
        Forum.stub!(:find_by_slug!).and_return(mock_forum(:update_attributes => true))
        put :update, :id => "1"
        assigns(:forum).should equal(mock_forum)
      end

      it "should redirect to the forum" do
        Forum.stub!(:find_by_slug!).and_return(mock_forum(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(forum_url(mock_forum))
      end

    end
    
    describe "with invalid params" do

      it "should update the requested forum" do
        Forum.should_receive(:find_by_slug!).with("37").and_return(mock_forum)
        mock_forum.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :forum => {:these => 'params'}
      end

      it "should expose the forum as @forum" do
        Forum.stub!(:find_by_slug!).and_return(mock_forum(:update_attributes => false))
        put :update, :id => "1"
        assigns(:forum).should equal(mock_forum)
      end

      it "should re-render the 'edit' template" do
        Forum.stub!(:find_by_slug!).and_return(mock_forum(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end

    end

  end

  describe "responding to DELETE destroy" do

    it "should destroy the requested forum" do
      Forum.should_receive(:find_by_slug!).with("37").and_return(mock_forum)
      mock_forum.should_receive(:destroy).and_return(true)
      delete :destroy, :id => "37"
    end
  
    it "should redirect to the forums list" do
      Forum.stub!(:find_by_slug!).and_return(mock_forum(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(forums_url)
    end

  end

end
