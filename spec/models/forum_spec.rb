require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Forum do
  before(:each) do
    @forum = Generate.forum
  end
  
  it { @forum.should validate_presence_of(:name) }
  
  it "should use it's slug as to_param" do
    @forum.to_param.should eql(@forum.slug)
    @forum.slug = "testing"
    @forum.to_param.should eql("testing")
  end
end
