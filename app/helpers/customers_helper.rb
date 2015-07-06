module CustomersHelper
  def errors_for(model_object, field_name)
    unless model_object.errors[field_name].empty?
      error_messages = model_object.errors[field_name].join(", ")
      content_tag(:span, error_messages, class: "error #{field_name}")
    end
  end
end
