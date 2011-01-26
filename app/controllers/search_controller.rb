# Right now this only searches plugins, but it would be great if it could search all objects
# in the system in the future.
class SearchController < ApplicationController

  FACET_ORDER= [
    [:supports_radiant_version, "Supported version"],
    [:author_name, "Author"],
    [:repository_type, "Repository type"],
    [:download_type, "Download type"]
  ]
  
  def search
    @query, @page = params[:q], params[:page]
    @facets, @plugins = {}, []
    @headline = ""
    unless @query.blank?
      scope = Plugin.best_first
      scope = scope.by_radiant_version(params[:supports_radiant_version]) if params[:supports_radiant_version]
      scope = scope.by_repository_type(params[:repository_type])          if params[:repository_type]
      scope = scope.by_download_type(params[:download_type])              if params[:download_type]
      scope = scope.by_author_name(params[:author_name])                  if params[:author_name]
      @facets = Plugin.facets @query, scope.options
      @plugins = scope.search @query, :match_mode=>:extended, :page=>@page, :per_page=>Plugin.per_page, :include=>:author
    end
  end
  
  protected
  
    def facet_order
      FACET_ORDER
    end
    helper_method :facet_order
  
    def results?
      !@query.blank? && @plugins.size>0
    end
    helper_method :results?
  
end