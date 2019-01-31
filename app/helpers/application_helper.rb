module ApplicationHelper
  def bootstrap_class_for flash_type
    { success: "alert-success", error: "alert-danger", alert: "alert-warning", notice: "alert-info" }[flash_type.to_sym] || flash_type.to_s
  end

  def what_time_is_it
    "#{Date.today().strftime('%A, %B %d, %Y')}"
  end

  def current_week_end_date
    Date.today().sunday
  end

  def previous_week(number)
    current_week_end_date - 7 * number
  end

  def date_to_param(val)
    val.strftime('%m/%d/%Y')
  end

  def format_date(val)
    val.strftime('%m/%d/%Y')
  end
end
