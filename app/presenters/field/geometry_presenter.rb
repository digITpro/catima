class Field::GeometryPresenter < FieldPresenter
  delegate :content_tag, :to => :view

  def input(form, method, options={})
    form.text_area(
      "#{method}_json",
      input_defaults(options).reverse_merge(:rows => 1)
    )
  end

  def value
    json = raw_value
    return if json.blank?
    content_tag(:span, "", :data => { "geo-json" => json })
  end

  private

  def input_data_defaults(data)
    super.reverse_merge("geo-input" => true)
  end
end