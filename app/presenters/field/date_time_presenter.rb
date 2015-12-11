class Field::DateTimePresenter < FieldPresenter
  delegate :l, :to => :view

  def value
    # TODO: format according to granularity of the field
    date = field.value_as_time_with_zone(item)
    date && l(date, :format => field.format.to_sym)
  end

  def input(form, method, options={})
    form.viim_datetime_select(
      "#{method}_time",
      input_defaults(options).merge(:format => field.format)
    )
  end
end