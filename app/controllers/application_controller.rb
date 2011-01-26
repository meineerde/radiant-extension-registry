# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password, :password_confirmation

  include AuthenticatedSystem
  include OpenIdAuthentication

  def can_edit?(model)
    case model
    when Plugin
      !!(current_author && ((current_author.id == model.author_id) || current_author.manager?))
    when Author
      !!(current_author && (current_author.id == model.id))
    else
      raise "unknown model #{model}:#{model.class}"
    end
  end
  helper_method :can_edit?


protected

  # can be used as a before_filter
  def render_403(error=nil)
    respond_to do |format|
      format.html {
        flash[:error] = error unless error.nil?
        render :template => "common/403", :status => 403
      }
      format.atom { head 403 }
      format.xml { head 403 }
      format.js { head 403 }
      format.json { head 403 }
    end
    return false
  end

  # can be used as a before_filter
  def render_404(error=nil)
    respond_to do |format|
      format.html {
        flash[:error] = error unless error.nil?
        render :template => "common/404", :status => 404
      }
      format.atom { head 404 }
      format.xml { head 404 }
      format.js { head 404 }
      format.json { head 404 }
    end
    return false
  end
end
