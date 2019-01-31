module LocationDrawReturnsHelper

  CELL_VALUE_TO_HIDE = -1

  def draw_edit_allowed?(day_of_week, draw_by_product)
    day_of_week = day_of_week + '_draw_edit_allowed'
    draw_by_product.method(day_of_week).call == 'Y' ? true : false
  end

  def return_edit_allowed?(day_of_week, draw_by_product)
    day_of_week = day_of_week + '_returns_edit_allowed'
    draw_by_product.method(day_of_week).call == 'Y' ? true : false
  end

  def show_day?(day_of_week, draw_by_product)
    net_draw(day_of_week, draw_by_product) > CELL_VALUE_TO_HIDE
  end

  def net_draw(day_of_week, draw_by_product)
    day_of_week = day_of_week + '_net_draw'
    draw_by_product.method(day_of_week).call
  end

  def day_returns(day_of_week, draw_by_product)
    day_of_week = day_of_week + '_returns'
    draw_by_product.method(day_of_week).call
  end

  def original_returns(day_of_week, draw_by_product)
    val = day_returns(day_of_week, draw_by_product)
    val == CELL_VALUE_TO_HIDE ? 0 : val
  end

  def zero_draw_reason_code(day_of_week, draw_by_product)
    draw_by_product.send(day_of_week + "_zero_draw_reason_code")
  end

  def zero_draw_reason_visible?(day_of_week, draw_by_product)
    net_draw(day_of_week, draw_by_product) == 0 && !zero_draw_reason_code(day_of_week, draw_by_product).blank?
  end
end
