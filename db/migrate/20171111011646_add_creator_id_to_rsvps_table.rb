class AddCreatorIdToRsvpsTable < ActiveRecord::Migration
  def change
    add_column :rsvps, :creator_id, :integer
  end
end
