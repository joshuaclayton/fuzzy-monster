require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ForumsController do
  describe "route generation" do
    it "should map #index" do
      route_for(:controller => "forums", :action => "index").should == "/forums"
    end
  
    it "should map #new" do
      route_for(:controller => "forums", :action => "new").should == "/forums/new"
    end
  
    it "should map #show" do
      route_for(:controller => "forums", :action => "show", :id => 1).should == "/forums/1"
    end
  
    it "should map #edit" do
      route_for(:controller => "forums", :action => "edit", :id => 1).should == "/forums/1/edit"
    end
  
    it "should map #update" do
      route_for(:controller => "forums", :action => "update", :id => 1).should == "/forums/1"
    end
  
    it "should map #destroy" do
      route_for(:controller => "forums", :action => "destroy", :id => 1).should == "/forums/1"
    end
  end

  describe "route recognition" do
    it "should generate params for #index" do
      params_from(:get, "/forums").should == {:controller => "forums", :action => "index"}
    end
  
    it "should generate params for #new" do
      params_from(:get, "/forums/new").should == {:controller => "forums", :action => "new"}
    end
  
    it "should generate params for #create" do
      params_from(:post, "/forums").should == {:controller => "forums", :action => "create"}
    end
  
    it "should generate params for #show" do
      params_from(:get, "/forums/1").should == {:controller => "forums", :action => "show", :id => "1"}
    end
  
    it "should generate params for #edit" do
      params_from(:get, "/forums/1/edit").should == {:controller => "forums", :action => "edit", :id => "1"}
    end
  
    it "should generate params for #update" do
      params_from(:put, "/forums/1").should == {:controller => "forums", :action => "update", :id => "1"}
    end
  
    it "should generate params for #destroy" do
      params_from(:delete, "/forums/1").should == {:controller => "forums", :action => "destroy", :id => "1"}
    end
  end
end
