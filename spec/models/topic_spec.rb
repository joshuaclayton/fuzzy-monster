require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Topic do
  before(:each) do
    @topic = Generate.topic
  end
  
  it { @topic.should validate_presence_of(:title) }
  it { @topic.should belong_to(:forum) }
  it { @topic.should belong_to(:creator) }
  
  it "should know how to be viewed" do
    hits = @topic.hits
    @topic.view!
    @topic.reload
    @topic.hits.should eql(hits + 1)
    
    1.upto(10) { @topic.view! }
    @topic.reload
    @topic.hits.should eql(hits + 11)
  end
  
  it "should use it's slug as to_param" do
    @topic.to_param.should eql(@topic.slug)
    @topic.slug = "testing"
    @topic.to_param.should eql("testing")
  end
end
