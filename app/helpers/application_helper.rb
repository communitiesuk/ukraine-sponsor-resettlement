require "csv"

module ApplicationHelper
  def format_date_of_birth(year, month, day)
    Date.new(year.to_i, month.to_i, day.to_i).strftime("%d %B %Y")
  rescue Date::Error
    "Unknown"
  end

  def get_formatted_certificate_number
    "CERT-#{generate_alpha_code(4)}-#{generate_digit_code(4)}-#{generate_alpha_code(1)}"
  end

  def get_nationalities_as_list(excludes = [])
    csv_file_path ||= File.read(
      File.join(File.dirname(__FILE__), "nationalities_list.csv"),
    )

    csv ||= CSV.parse(csv_file_path, col_sep: ",", row_sep: :auto, skip_blanks: true)

    nationalities ||= [OpenStruct.new(val: "---", name: "---")]
    csv.sort_by { |nationality| nationality[1] }.each_with_index do |row, index|
      next if index.zero? # skip headers
      next if excludes.include?(["#{row[0]} - #{row[1]}"])

      nationalities << OpenStruct.new(val: "#{row[0]} - #{row[1]}", name: (row[1]).to_s)
    end

    nationalities
  end

  def last_seen_activity_threshold
    30.minutes
  end

private

  def generate_alpha_code(number)
    charset = Array("A".."Z")
    Array.new(number) { charset.sample }.join
  end

  def generate_digit_code(number)
    numbers = Array("0".."9")
    Array.new(number) { numbers.sample }.join
  end
end
