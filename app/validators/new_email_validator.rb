# custom email validator to check that new email is not the same as the current email
class NewEmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    value = value.strip.upcase
    if value == record.email_address.strip
      record.errors[attribute] << (options[:message] || "New email is the same as the current email address")
    # PortalUser is not appropriate model for checking the email address for unqueness.
    # elsif PortalUser.where(eards: value).any?
    #   record.errors[attribute] << (options[:message] || "This email address has already been taken")
    end
  end
end

