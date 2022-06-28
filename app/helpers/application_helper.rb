module ApplicationHelper
  def format_date_of_birth(date_of_birth)
    months = ["", "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]

    "#{date_of_birth['3']} #{months[date_of_birth['2']]} #{date_of_birth['1']}"
  end
end
