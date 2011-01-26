require File.dirname(__FILE__) + '/../spec_helper'

describe PluginsController do
  dataset :plugins
  
  integrate_views
  
  describe "index action" do
    it "should not require login" do
      controller.should_not_receive(:access_denied)
      get :index
      response.should_not be_redirect
    end
    
    it "should load a list of paginated plugins" do
      get :index
      assigns[:plugins].should_not be_blank
    end
    
    it "should render the index template" do
      get :index
      response.should render_template('index')
    end
    
    it "should provide XML" do
      get :index, :format => 'xml'
      response.headers['Content-Type'].should match(/xml/)
    end
  end
  
  describe "all action" do
    
    it "should not require login" do
      controller.should_not_receive(:access_denied)
      get :all
      response.should_not be_redirect
    end
    
    describe "unpaginated" do
      dataset :paginated
      
      it "should load a list of all plugins" do
        get :all
        assigns[:plugins].should_not be_blank
        assigns[:plugins].size.should == Plugin.count
        response.should render_template(:index)
      end
      
    end
  end
  
  describe "show action" do
    it "should not require login" do
      controller.should_not_receive(:access_denied)
      get :show, :id => plugin_id(:page_attachments)
      response.should_not be_redirect
    end
    
    it "should load a plugin by id" do
      get :show, :id => plugin_id(:page_attachments)
      assigns[:plugin].should == plugins(:page_attachments)
    end
    
    it "should render the show template" do
      get :show, :id => plugin_id(:page_attachments)
      response.should render_template('show')
    end
    
    it "should should provide XML" do
      get :show, :id => plugin_id(:page_attachments), :format => 'xml'
      response.headers['Content-Type'].should match(/xml/)
    end
  end
  
  describe "new action" do
    before :each do
      login_as(:quentin)
    end
    
    it "should require login" do
      logout
      get :new
      response.should be_redirect
    end
    
    it "should render the new template" do
      get :new
      response.should render_template('new')
    end
    
    it "should load a new plugin" do
      get :new
      assigns[:plugin].should_not be_nil
      assigns[:plugin].should be_new_record
    end
  end
  
  describe "create action" do
    before :each do
      login_as :quentin
      @plugin = plugins(:page_attachments)
      Plugin.stub!(:new).and_return(@plugin)
    end
    
    it "should require login" do
      logout
      post :create
      Plugin.should_not_receive(:new)
      response.should be_redirect
    end

    describe "when save succeeds" do
      before :each do
        @plugin.should_receive(:save).and_return(true)
      end
      
      it "should set the author" do
        @plugin.should_receive(:author=).with(authors(:quentin))
        post :create
      end
      
      it "should redirect" do
        post :create
        response.should be_redirect
      end
      
      it "should build the plugin object" do
        post :create
        assigns[:plugin].should == @plugin
      end
      
      it "should create the object when XML" do
        put :create, :format => 'xml'
        (200..299).should include(response.response_code)
      end
      
    end
    
    describe "when save fails" do
      before :each do
        @plugin.should_receive(:save).and_return(false)
      end
      
      it "should render the new template" do
        post :create
        response.should render_template('new')
      end
      
      it "should render errors when XML" do
        put :create
        response.should_not be_success
      end
    end
    
  end
  
  describe "edit action" do
    before :each do
      login_as :seancribbs
    end
    
    it "should require login" do
      logout
      get :edit, :id => plugin_id(:page_attachments)
      response.should be_redirect
    end
    
    it "should require the author to be the owner of the plugin" do
      login_as :aaron
      get :edit, :id => plugin_id(:page_attachments)
      response.should be_redirect
      flash[:error].should_not be_nil
    end
    
    it "should load the given plugin" do
      get :edit, :id => plugin_id(:page_attachments)
      assigns[:plugin].should == plugins(:page_attachments)
    end
    
    it "should render the edit template" do
      get :edit, :id => plugin_id(:page_attachments)
      response.should render_template('edit')
    end
  end
  
  describe "update action" do
    before :each do
      login_as :seancribbs
      @plugin = plugins(:page_attachments)
    end
    
    it "should require login" do
      logout
      put :update, :id => @plugin.id, :plugin => { :name => "changed" }
      plugins(:page_attachments).name.should == "page_attachments"
      response.should be_redirect
    end
    
    it "should require the author to be the owner of the plugin" do
      login_as :aaron
      put :update, :id => plugin_id(:page_attachments), :plugin => { :name => "changed" }
      plugins(:page_attachments).name.should == "page_attachments"
      response.should be_redirect
      flash[:error].should_not be_nil
    end

    describe "when save succeeds" do
      it "should redirect" do
        put :update, :id => plugin_id(:page_attachments), :plugin => { :name => "changed" }
        plugins(:page_attachments).name.should == "changed"
        response.should be_redirect
      end
      
      it "should build the plugin object" do
        put :update, :id => plugin_id(:page_attachments), :plugin => { :name => "changed" }
        plugins(:page_attachments).name.should == "changed"
        assigns[:plugin].should == @plugin
      end
      
      it "should update the object when XML" do
        put :update, :id => plugin_id(:page_attachments), :plugin => { :name => "changed" }, :format => 'xml'
        plugins(:page_attachments).name.should == "changed"
        (200..299).should include(response.response_code)
      end
    end
    
    describe "when save fails" do
      it "should render the edit template" do
        put :update, :id => plugin_id(:page_attachments), :plugin => { :name => "" }
        response.should render_template('edit')
        plugins(:page_attachments).name.should == "page_attachments"
      end
      
      it "should render errors when XML" do
        put :update, :id => plugin_id(:page_attachments), :plugin => { :name => "" }, :format => 'xml'
        response.should_not be_success
        plugins(:page_attachments).name.should == "page_attachments"
      end
    end
  end
  
  describe "destroy action" do
    before :each do
      login_as :seancribbs
      @plugin = plugins(:page_attachments)
    end
    
    it "should require login" do
      logout
      delete :destroy, :id => @plugin.id
      Plugin.find_by_id(@plugin.id).should_not be_nil
      response.should be_redirect
    end
    
    it "should require the author to be the owner of the plugin" do
      login_as :aaron
      delete :destroy, :id => @plugin.id
      Plugin.find_by_id(@plugin.id).should_not be_nil
      response.should be_redirect
      flash[:error].should_not be_nil
    end
    
    it "should destroy and redirect" do
      delete :destroy, :id => @plugin.id
      Plugin.find_by_id(@plugin.id).should be_nil
      response.should be_redirect
    end
    
    it "should destroy when XML" do
      delete :destroy, :id => @plugin.id, :format => 'xml'
      Plugin.find_by_id(@plugin.id).should be_nil
      (200..299).should include(response.response_code)
    end
  end
end
