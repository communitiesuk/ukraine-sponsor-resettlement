class UpdateMinorDateOfBirth < ActiveRecord::Migration[7.0]
  def up
    execute <<-EOSQL
      WITH cte_uam AS (
        SELECT
            um.id
          , jsonb_pretty((um.answers::jsonb - 'minor_date_of_birth_day' - 'minor_date_of_birth_month' - 'minor_date_of_birth_year')
            || CONCAT('{"minor_date_of_birth":{"3":',(answers->>'minor_date_of_birth_day')::INT, ', "2":',(answers->>'minor_date_of_birth_month')::INT, ', "1":',(answers->>'minor_date_of_birth_year')::INT, '}}')::jsonb ) AS fixed
        FROM
          unaccompanied_minors um
        WHERE
          (answers->>'minor_date_of_birth_day' IS NOT NULL)
      )
      UPDATE unaccompanied_minors
      SET answers = (cte_uam.fixed)::json
      FROM cte_uam
      WHERE unaccompanied_minors.id = cte_uam.id;
    EOSQL
  end

  def down
    # no op
  end
end
