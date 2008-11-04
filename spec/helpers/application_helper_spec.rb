require File.dirname(__FILE__) + '/../spec_helper'

describe ApplicationHelper do
  it "should know how to generate an array of breadcrumbs" do
    helper.breadcrumbs.should eql(["Forums"])
    @forum = Generate.forum
    @topic = Generate.topic(:forum => @forum)
    helper.breadcrumbs(:forum => @forum).should eql([link_to("Forums", forums_path), @forum.name])
    helper.breadcrumbs(:topic => @topic).should eql([link_to("Forums", forums_path), link_to(@forum.name, forum_path(@forum)), @topic.title])
  end
end
