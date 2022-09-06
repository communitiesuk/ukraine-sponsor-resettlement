class UpdateSponsorDateOfBirth < ActiveRecord::Migration[7.0]
  def up
    execute <<-EOSQL
      WITH cte_uam AS (
        SELECT
            um.id
          , jsonb_pretty((um.answers::jsonb - 'sponsor_date_of_birth_day' - 'sponsor_date_of_birth_month' - 'sponsor_date_of_birth_year')
            || CONCAT('{"sponsor_date_of_birth":{"3":',answers->>'sponsor_date_of_birth_day', ', "2":', answers->>'sponsor_date_of_birth_month', ', "1":', answers->>'sponsor_date_of_birth_year', '}}')::jsonb ) AS fixed
        FROM
          unaccompanied_minors um
        WHERE
          (answers->>'sponsor_date_of_birth_day' IS NOT NULL)
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
