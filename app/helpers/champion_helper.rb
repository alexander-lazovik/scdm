# /app/helpers/champion_helper.rb
# This helper contains misc. methods to interpret Champion things to html and back
module ChampionHelper

  # Champion stores returns as -1 if there is no entry. users want to see a space
  def eval_to_space(val)
    val == -1 ? '' : val
  end

  def format_to_phone_number(number_to_format)
    formated_phone_number = number_to_format.truncate.to_s
    if formated_phone_number.length >= 7
      formated_phone_number.insert(6, '-')
      formated_phone_number.insert(3, ") " )
      formated_phone_number.insert(0, "(" )
    else
      formated_phone_number = 'Not Available'
    end
    formated_phone_number
  end

  def get_next_edition_date
    Date.parse(NextEdition.first.next_edition_date.to_s).strftime('%m/%d/%Y')
  end

  # Models keep ids as numbers. Users want to see leading zeroes
  def format_id_to_s(id)
    id.to_s.rjust(3, '0')
  end

  # Champion stores dates in YYYYMMDD Fixnum format.
  # Convert it to MM/DD/YYYY string format
  def format_date_to_s(val)
    Date.parse(val.to_s).strftime('%m/%d/%Y')
  end

  # convert string MM/DD/YYYY to Champion date format YYYYMMDD
  def format_s_to_date(val)
    Date.strptime(val, '%m/%d/%Y').strftime("%Y%m%d")
  end
end
