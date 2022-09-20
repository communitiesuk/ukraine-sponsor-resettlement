class AddSponsorPhoneNumberConfirmation < ActiveRecord::Migration[7.0]
  def up
    execute <<-EOSQL
    WITH cte_uam AS (
      SELECT
        um.id
        , ((um.answers::jsonb) || CONCAT('{"phone_number_confirm":"', um.answers->>'phone_number', '"}')::jsonb)::json AS fixed
      FROM
        unaccompanied_minors um
      WHERE
        (answers->>'phone_number' IS NOT NULL AND answers->>'phone_number_confirm' IS NULL)
    )
    UPDATE
      unaccompanied_minors
    SET
      answers = (cte_uam.fixed)::json
    FROM
      cte_uam
    WHERE
      unaccompanied_minors.id = cte_uam.id;
    EOSQL
  end

  def down
    # no op
  end
end
