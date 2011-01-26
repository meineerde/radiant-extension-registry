class PluginsController < ApplicationController
  before_filter :login_required, :except => [:index, :all, :show]
  before_filter :find_plugin, :only => [:show, :edit, :update, :destroy]
  before_filter :require_correct_permissions, :only => [:edit, :update, :destroy]

  ORDER_BY = {
    'name' => 'name',
    'updated' => 'updated_at DESC'
  }
  
  # GET /plugins
  # GET /plugins.xml
  # GET /plugins.atom
  def index
    @order = params[:order]
    @order ||= 'name'
    
    respond_to do |format|
      format.html { @plugins = Plugin.paginate :page => params[:page], :order => ORDER_BY[@order], :include => :author }
      format.xml  { @plugins = Plugin.find(:all, :order=>"updated_at DESC", :include => :author); render :xml => @plugins }
      format.atom { @plugins = Plugin.find(:all, :order=>"updated_at DESC", :include => :author) }
    end
  end
  
  # GET /plugins/all
  def all
    @plugins = Plugin.paginate :page => params[:page], :order => 'name', :per_page => Plugin.count, :include => :author
    render :action => :index
  end
  
  # GET /plugins/1
  # GET /plugins/1.xml
  def show
    respond_to do |format|
      format.html
      format.xml { render :xml => @plugin }
    end
  end
  
  # GET /plugins/new
  def new
    @plugin = Plugin.new
  end
  
  # GET /plugins/1/edit
  def edit
  end
  
  # POST /plugins
  # POST /plugins.xml
  def create
    @plugin = Plugin.new(params[:plugin])
    @plugin.author = current_author
    respond_to do |format|
      if @plugin.save
        format.html {
          flash[:notice] = 'Created successfully!'
          redirect_to plugin_url(@plugin)
        }
        format.js
        format.xml  { head :created, :location => plugin_url(@plugin) }
      else
        format.html {
          flash[:error] = 'There was a problem!'
          render :action => "new", :status => :unprocessible_entity
        }
        format.js
        format.xml  { render :xml => @plugin.errors.to_xml, :status => :unprocessible_entity }
      end
    end
  end
  
  # PUT /plugins/1
  # PUT /plugins/1.xml
  def update
    respond_to do |format|
      if @plugin.update_attributes(params[:plugin])
        format.html {
          flash[:notice] = 'Updated successfully!'
          redirect_to plugin_url(@plugin) }
        format.js
        format.xml  { head :ok }
      else
        format.html {
          flash[:error] = 'There was a problem saving!'
          render :action => "edit", :status => :unprocessible_entity
        }
        format.js
        format.xml  { render :xml => @plugin.errors.to_xml, :status => :unprocessible_entity }
      end
    end
  end

  # DELETE /plugins/1
  # DELETE /plugins/1.xml
  def destroy
    if @plugins.destroy
      respond_to do |format|
        format.html { flash[:notice] = "Plugin deleted!"; redirect_to plugins_url }
        format.js
        format.xml  { head :ok }
      end
    else
      respond_to do |format|
        format.html {
          flash[:error] = "There was a problem deleting!"
          redirect_to :back, :status => :failure
        }
        format.js
        format.xml  { head :failure }
      end
    end
  end
  
  protected
    
    def find_plugin
      @plugin = Plugin.find(params[:id])
    end
    
    def require_correct_permissions
      unless can_edit?(@plugin)
        respond_to do |format|
          format.html do
            flash[:error] = "You can only edit your own plugins."
            redirect_to plugins_url
          end
          format.xml { head :forbidden }
        end
        return false
      end
    end
  
end