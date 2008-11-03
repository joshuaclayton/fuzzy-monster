require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe TopicsController do
  describe "route generation" do
    it "should map #index" do
      route_for(:controller => "topics", :action => "index", :forum_id => "1").should == "/forums/1/topics"
    end
  
    it "should map #new" do
      route_for(:controller => "topics", :action => "new", :forum_id => "1").should == "/forums/1/topics/new"
    end
  
    it "should map #show" do
      route_for(:controller => "topics", :action => "show", :forum_id => "1", :id => 1).should == "/forums/1/topics/1"
    end
  
    it "should map #edit" do
      route_for(:controller => "topics", :action => "edit", :forum_id => "1", :id => 1).should == "/forums/1/topics/1/edit"
    end
  
    it "should map #update" do
      route_for(:controller => "topics", :action => "update", :forum_id => "1", :id => 1).should == "/forums/1/topics/1"
    end
  
    it "should map #destroy" do
      route_for(:controller => "topics", :action => "destroy", :forum_id => "1", :id => 1).should == "/forums/1/topics/1"
    end
  end

  describe "route recognition" do
    it "should generate params for #index" do
      params_from(:get, "/forums/1/topics").should == {:controller => "topics", :action => "index", :forum_id => "1"}
    end
  
    it "should generate params for #new" do
      params_from(:get, "/forums/1/topics/new").should == {:controller => "topics", :action => "new", :forum_id => "1"}
    end
  
    it "should generate params for #create" do
      params_from(:post, "/forums/1/topics").should == {:controller => "topics", :action => "create", :forum_id => "1"}
    end
  
    it "should generate params for #show" do
      params_from(:get, "/forums/1/topics/1").should == {:controller => "topics", :action => "show", :forum_id => "1", :id => "1"}
    end
  
    it "should generate params for #edit" do
      params_from(:get, "/forums/1/topics/1/edit").should == {:controller => "topics", :action => "edit", :forum_id => "1", :id => "1"}
    end
  
    it "should generate params for #update" do
      params_from(:put, "/forums/1/topics/1").should == {:controller => "topics", :action => "update", :forum_id => "1", :id => "1"}
    end
  
    it "should generate params for #destroy" do
      params_from(:delete, "/forums/1/topics/1").should == {:controller => "topics", :action => "destroy", :forum_id => "1", :id => "1"}
    end
  end
end
