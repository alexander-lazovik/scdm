# Returns validator
class ReturnsValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    # champion needs -1 instead of nil
    record.send(attribute.to_s + "=", -1) if value.nil?

    # Do not validate if attribute was not modified
    day_of_week = attribute.to_s.sub("_returns", "")
    return unless ["R", "B"].include?(record.send(day_of_week + "_update_type"))

    # net draw associated for the previous RDL Date
    returns_day_net_draw = record.try("returns_day_net_draw")

    if record.send(day_of_week + "_returns_edit_allowed") != "Y"
      record.errors[attribute] << "Returns cannot be changed"
    elsif value.nil? # allow nil value
    elsif value < 0
      record.errors[attribute] << "Returns cannot be a negative number"
    elsif value % 1 > 0
      record.errors[attribute] << "Returns must be an integer"
    elsif !returns_day_net_draw && value > record.send(day_of_week + "_net_draw")
      # On the Weekly page returns cannot exceed the draw value
      record.errors[attribute] << "Returns cannot be greater than Draw"
    elsif returns_day_net_draw && value > returns_day_net_draw
      # On the RDL page returns cannot exceed the draw value for the same distribution date
      record.errors[attribute] << "Return value cannot exceed draw value of #{returns_day_net_draw}"
    end
  end
end

