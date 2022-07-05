module ApplicationHelper
  def format_date_of_birth(date_of_birth)
    months = ["", "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]

    "#{date_of_birth['3']} #{months[date_of_birth['2']]} #{date_of_birth['1']}"
  end

  def get_formatted_certificate_number
    "CERT-#{generate_alpha_code(4)}-#{generate_digit_code(4)}-#{generate_alpha_code(1)}"
  end

private
  def generate_alpha_code(number)
    charset = Array('A'..'Z')
    Array.new(number) { charset.sample }.join
  end

  def generate_digit_code(number)
    numbers = Array('0'..'9')
    Array.new(number) { numbers.sample }.join
  end
end
