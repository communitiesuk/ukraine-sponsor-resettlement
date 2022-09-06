class UpdateMinorContactType < ActiveRecord::Migration[7.0]
  def up
    execute <<-EOSQL
      WITH cte_uam AS (
        SELECT
          um.id
          , jsonb_pretty((um.answers::jsonb - 'minor_contact_type') || CONCAT('{"minor_contact_type":["","', um.answers->>'minor_contact_type', '"]}')::jsonb ) AS fixed
        FROM
        unaccompanied_minors um
      WHERE
        (um.answers->>'minor_contact_type' IN('none', 'email', 'telephone'))
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
