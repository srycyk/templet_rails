
# Produces output for all JSON requests
module Templet::JsonRenderingHelpers
  private

  def json_for(model, status: :ok, in_error: false)
    model, status = model.errors, :unprocessable_entity if in_error

    { json: model, status: status, location: "#{controller_name}/#{action_name}" }
  end
end

