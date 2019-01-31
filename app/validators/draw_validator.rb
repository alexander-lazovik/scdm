# Draw validator
class DrawValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    # champion needs -1 instead of nil
    record.send(attribute.to_s + "=", -1) if value.nil?

    # Do not validate if attribute was not modified
    day_of_week = attribute.to_s.sub("_net_draw", "")
    return unless ["D", "B"].include?(record.send(day_of_week + "_update_type"))

    # returns associated with the RDL Date
    draw_day_returns = record.try("draw_day_returns")

    if record.send(day_of_week + "_draw_edit_allowed") != "Y"
      record.errors[attribute] << "Draw cannot be changed"
    elsif value.blank?
      record.errors[attribute] << "Draw cannot be blank"
    elsif value < 0
      record.errors[attribute] << "Draw cannot be a negative number"
    elsif value == 0 && record.send(day_of_week + "_zero_draw_reason_code").blank?
      record.errors[(day_of_week + "_zero_draw_reason_code").to_sym] << "Select a reason for 0 Draw"
    elsif value % 1 > 0
      record.errors[attribute] << "Draw must be an integer"
    elsif value > record.product_order_draw_threshold_max
      record.errors[attribute] << "Draw exceeds max allowed draw"
    elsif draw_day_returns && value < draw_day_returns
      record.errors[attribute] << "Draw value cannot be less than returns value of #{draw_day_returns}"
    end

    # if the user changes the draw to a value > 0,
    # the zero draw reason code should be sent as blank to the back end system
    record.send(day_of_week + "_zero_draw_reason_code=", "") if value > 0
  end
end

