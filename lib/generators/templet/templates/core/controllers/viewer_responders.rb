
# Used in controller actions to dispatch the HTML, JS & JSON formats
module Templet::ViewerResponders
  include Templet::RenderingHelpers

  include Templet::JsonRenderingHelpers

  private

  def respond_to_index(models_name=nil, models=nil, **options)
    models_name ||= model_name.to_s.pluralize

    respond_to do |format|
      format.html do
        render inline viewer(:index, **merge_models(options, models_name))
      end

      format.js do
        render js viewer_to_s(:index, **merge_models(options, models_name))
      end

      format.json do
        render json_for(models || instance_var(models_name))
      end
    end
  end

  def respond_to_action(action, model=nil, **options)
    respond_to do |format|
      format.html { render inline viewer(action, **options) }

      format.js { render js viewer_to_s(action, **options) }

      format.json { render json_for(model || instance_var(model_name)) }
    end
  end

  def respond_to_show(*args)
    respond_to_action :show, *args
  end
  def respond_to_new(*args)
    respond_to_action :new, *args
  end
  def respond_to_edit(*args)
    respond_to_action :edit, *args
  end

  def respond_to_save_success(model, redirect=model, status=nil,
                              notice=nil, **options)
    status ||= model.id_previously_changed? ? :created : :ok

    notice ||= default_notice(model)

    respond_to do |format|
      format.html do
        redirect_to redirect, notice: notice
      end

      format.js do
        set_message(notice)

        render js viewer_to_s(:show, **options)
      end

      format.json { render json_for(model, status: status) }
    end
  end

  def respond_to_save_failure(action, model, **options)
    respond_to do |format|
      format.html { render inline viewer(action, **options) }

      format.js { render js viewer_to_s(action, **options) }

      format.json { render json_for(model, in_error: true) }
    end
  end

  def respond_to_destroy(model, redirect=model, notice=nil)
    notice ||= default_notice(model, "deleted")

    respond_to do |format|
      format.html { redirect_to redirect, notice: notice }

      format.js do
        set_message(notice)

        index
      end

      format.json { head :no_content }
    end
  end

  def merge_models(options, models_name)
    options.merge models: to_iv(models_name)
  end

  def instance_var(name)
    instance_variable_get to_iv(name)
  end

  def to_iv(name)
    name.to_s.start_with?('@') ? name : "@#{name}".to_sym
  end

  def default_notice(model, suffix=nil, prefix=nil)
    "#{prefix || notice_prefix} #{model} #{suffix || notice_suffix}."
  end
  def notice_prefix
    model_name.to_s.capitalize
  end
  def notice_suffix
    action_name + 'd'
  end

  def set_message(text, key=:notice)
    flash.now[key] = text
  end
end

