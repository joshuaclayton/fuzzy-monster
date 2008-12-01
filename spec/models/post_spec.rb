require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Post do
  before(:each) do
    @post = Generate.post
  end
  
  it { @post.should be_valid }
  it { @post.should belong_to(:forum) }
  it { @post.should belong_to(:topic) }
  it { @post.should belong_to(:author) }
  it { @post.should validate_presence_of(:author_id) }
  it { @post.should validate_presence_of(:forum_id) }
  it { @post.should validate_presence_of(:topic_id) }
  it { @post.should validate_presence_of(:body) }
end
