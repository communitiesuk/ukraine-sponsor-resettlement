require "csv"

module ApplicationHelper
  def format_date_of_birth(year, month, day)
    begin
      Date.new(year.to_i, month.to_i, day.to_i).strftime("%dd %MMMM %Y")
    rescue Date::Error
      "Unknown"
    end
  end

  def get_formatted_certificate_number
    "CERT-#{generate_alpha_code(4)}-#{generate_digit_code(4)}-#{generate_alpha_code(1)}"
  end

  def get_nationalities_as_list
    csv_file_path ||= File.read(
      File.join(File.dirname(__FILE__), "nationalities_list.csv"),
    )

    csv ||= CSV.parse(csv_file_path, col_sep: ",", row_sep: :auto, skip_blanks: true)

    nationalities ||= []
    csv.each_with_index do |row, index|
      next if index.zero? # skip headers

      nationalities << OpenStruct.new(val: "#{row[0]} - #{row[1]}", name: (row[1]).to_s)
    end
    nationalities
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
