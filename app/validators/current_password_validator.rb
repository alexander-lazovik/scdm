# Current password validator
# Emulate logging in to check if the current password is valid
class CurrentPasswordValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless LoginUser.new({email_address: record.email_address, password: record.current_password}).validate_password
      record.errors[attribute] << (options[:message] || "Your password or user id is invalid")
    end
  end
end

