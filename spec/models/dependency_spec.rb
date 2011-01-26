require File.dirname(__FILE__) + '/../spec_helper'

describe Dependency do
  dataset :plugins
  
  before(:each) do
    @dependency = Dependency.new(:plugin_id => plugin_id(:page_attachments), :satisfier_id => plugin_id(:reorder))
  end

  it "should not allow simple circular dependencies" do
    @dependency.plugin_id = @dependency.satisfier_id = plugins(:page_attachments)
    @dependency.should_not be_valid
    @dependency.should have(1).error_on(:base)
  end
  
  it "should require a plugin" do
    @dependency.plugin_id = nil
    @dependency.should_not be_valid
    @dependency.should have(1).error_on(:plugin_id)
  end

  it "should require a satisfier" do
    @dependency.satisfier_id = nil
    @dependency.should_not be_valid
    @dependency.should have(1).error_on(:satisfier_id)
  end
  
end
