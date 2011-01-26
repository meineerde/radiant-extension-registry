class Dependency < ActiveRecord::Base
  validates_presence_of :plugin_id, :satisfier_id
  validate :disallow_circular_dependency
  
  protected
    def disallow_circular_dependency
      if plugin_id && satisfier_id && plugin_id == satisfier_id
        errors.add_to_base("cannot be dependent on itself")
      end
    end
end
