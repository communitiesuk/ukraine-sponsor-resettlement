class UpdateEmailDateOfBirth < ActiveRecord::Migration[7.0]
  def change
    UnaccompaniedMinor.all.each do |uam|
      # migrates the old date of birth from
      # 3 separate values to _date_of_birth = {3: day, 2: month, 1: year}
      #
      # migrates the old email from
      # a string to an array ["", "email"] or ["", "none"]

      updated_answers = uam.answers.deep_dup

      if uam.answers.key?("sponsor_date_of_birth_day")
        sponsor_date_of_birth = {
          "3" => uam.answers["sponsor_date_of_birth_day"],
          "2" => uam.answers["sponsor_date_of_birth_month"],
          "1" => uam.answers["sponsor_date_of_birth_year"],
        }
        updated_answers = updated_answers.except(
          "sponsor_date_of_birth_day", "sponsor_date_of_birth_month", "sponsor_date_of_birth_year"
        )
        updated_answers["sponsor_date_of_birth"] = sponsor_date_of_birth
      end

      if uam.answers.key?("minor_date_of_birth_day")
        minor_date_of_birth = {
          "3" => uam.answers["minor_date_of_birth_day"],
          "2" => uam.answers["minor_date_of_birth_month"],
          "1" => uam.answers["minor_date_of_birth_year"],
        }
        updated_answers = updated_answers.except(
          "minor_date_of_birth_day", "minor_date_of_birth_month", "minor_date_of_birth_year"
        )
        updated_answers["minor_date_of_birth"] = minor_date_of_birth
      end

      if uam.answers.key?("minor_contact_type") && (uam.answers["minor_contact_type"].is_a? String)
        updated_answers["minor_contact_type"] = ["", uam.answers["minor_contact_type"]]
      end

      if uam.answers != updated_answers
        uam.assign_attributes(updated_answers)
        uam.save!(validate: false)
      end
    end
  end
end
