
#require 'templet/require_all'
#require 'app'

module TempletHelper
  def icon(name)
     "<span class='glyphicon glyphicon-#{name}'></span>".html_safe
  end
end

