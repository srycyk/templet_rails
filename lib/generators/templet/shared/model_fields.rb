
module Shared
  module ModelFields
    private

    def model_fields(model_name)
      if klass = model_class(model_name)
        klass.column_names.reject do |name|
          %w(id created_at updated_at).include? name
        end
      else
        []
      end
    end

    def textual_field_with_tag(model_name)
      name, type = field_with_type(model_name, %i(string text))

      return name, (type == :text ? 'textarea' : 'input')
    end

    #

    def field_with_type(model_name, types)
      names_to_types = model_types(model_fields model_name)

      names_to_types.each do |(name, type)|
        types.each do |wanted_type|
          return name, type if type == wanted_type
        end
      end
      nil
    end

    def model_types(model_fields)
      model_fields.map do |name|
        type = model_field_type(model_name, name)

        [ name.to_sym, type.to_sym ]
      end
    end

    def model_field_type(model_name, field_name)
      if klass = model_class(model_name)
        column = klass.columns.detect {|column| column.name == field_name.to_s }

        column&.type
      end
    end

    def model_class(name)
      name.classify.constantize rescue nil
    end
  end
end
