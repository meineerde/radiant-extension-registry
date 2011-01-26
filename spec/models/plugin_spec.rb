require File.dirname(__FILE__) + '/../spec_helper'

describe Plugin do
  dataset :plugins
  
  before(:each) do
    @plugin = Plugin.new(plugin_params)
  end

  it "should require a name" do
    @plugin.name = nil
    @plugin.should_not be_valid
    @plugin.should have(1).error_on(:name)
  end

  it "should require a unique name" do
    @plugin.name = plugins(:page_attachments).name
    @plugin.should_not be_valid
    @plugin.should have(1).error_on(:name)
  end
  
  it "should require a repository url or download url" do
    @plugin.download_url = nil
    @plugin.repository_url = nil
    @plugin.should_not be_valid
    @plugin.should have(1).error_on(:repository_url)
    @plugin.should have(1).error_on(:download_url)
  end
  
  it "should not require a download url if repository url is present" do
    @plugin.repository_url.should_not be_nil
    @plugin.should be_valid
  end
  
  it "should not require a repository url if a download url is present" do
    @plugin.repository_url = nil
    @plugin.download_url = "http://seancribbs.com/download/test_plugin.tar.gz"
    @plugin.download_type = "Tarball"
    @plugin.should be_valid
  end
  
  it "should require the repository url to be unique if present" do
    @plugin.repository_url = plugins(:page_attachments).repository_url
    @plugin.should_not be_valid
  end
  
  it "should require the download url to be unique if present" do
    @plugin.download_url = plugins(:page_attachments).download_url
    @plugin.should_not be_valid
  end
  
  it "should be valid" do
    @plugin.should be_valid
  end
  
  it "should have a friendly URL parameter" do
    @plugin.save
    @plugin.to_param.should match(/^\d+-test$/)
  end
  
  it "should require an author" do
    @plugin.author_id = nil
    @plugin.should_not be_valid
    @plugin.should have(1).error_on(:author_id)
  end
  
  it "should require the download type when a download url is provided" do
    @plugin = plugins(:taronly)
    @plugin.download_type = nil
    @plugin.download_url.should_not be_nil
    @plugin.should_not be_valid
    @plugin.should have(1).error_on(:download_type)
  end
  
  it "should require the repository type when a repository url is provided" do
    @plugin = plugins(:gitonly)
    @plugin.repository_type = nil
    @plugin.repository_url.should_not be_nil
    @plugin.should_not be_valid
    @plugin.should have(1).error_on(:repository_type)
  end
  
  it "should provide install type for backward-compatibility" do
    @plugin = plugins(:page_attachments)
    @plugin.install_type.should == @plugin.repository_type
    
    @plugin = plugins(:taronly)
    @plugin.install_type.should == @plugin.download_type
    
    @plugin = plugins(:gitonly)
    @plugin.install_type.should == @plugin.repository_type
  end
  
  it "should update the plugin count on author when a new one is created" do
    @author = authors(:seancribbs)
    count = @author.plugins_count
    3.times { |i| Plugin.create!(plugin_params(:name => i.to_s, :author_id => author_id(:seancribbs))) }
    @author.reload
    @author.plugins_count.should == count + 3
  end
  
  it "should decrement the plugin count on author when a plugin is deleted" do
    @author = authors(:seancribbs)
    count = @author.plugins_count
    @author.plugins.last.destroy
    @author.reload
    @author.plugins_count.should == (count - 1)
  end
end
