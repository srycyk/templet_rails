
# Helper methods used in controller actions to render views
module Templet::RenderingHelpers
  include ActionView::Helpers::JavaScriptHelper

  private

  # Calls a Viewer class
  def viewer(action, model_name=nil, **options)
    options = viewer_options.merge(options)

    model_name ||= options.delete(:model_name) || model_name()

    Templet::ViewerCallString.new(action, model_name, **options)
  end

  # For JS requests
  def viewer_to_s(*args, **options)
    options.reverse_merge! wrapper: render_target

    render_to_string inline viewer(*args, **options)
  end
  def js(html, target=nil)
    target ||= "#panel-#{render_target}"

    { js: "$('#{target}').html('#{escape_javascript html}')" }
  end

  # Invokes the Rails-supplied render option
  def inline(ruby_code, has_layout=false)
    { inline: "<%= (#{ruby_code}).html_safe %>", layout: has_layout }
  end

  # The following methods are defaults that can be overridden in the controller

  # Used by the Viewer extensively, it points to the main instance variable,
  # is shown in default headings, etc.
  def model_name
    controller_name.singularize
  end

  # Default options passed into the Viewer by each controller action
  # You can specify the name of a controller's parent model here
  def viewer_options
    { controller: params[:controller] }
  end

  # The HTML id (within the panel) into which JS (remote) output is inserted
  def render_target
    :outer
  end
end

