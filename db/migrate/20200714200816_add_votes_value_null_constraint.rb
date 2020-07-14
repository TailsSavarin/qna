class AddVotesValueNullConstraint < ActiveRecord::Migration[6.0]
  def change
    change_column_null :votes, :value, false
  end
end
