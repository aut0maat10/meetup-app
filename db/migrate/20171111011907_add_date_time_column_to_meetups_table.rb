class AddDateTimeColumnToMeetupsTable < ActiveRecord::Migration
  def change
    add_column :meetups, :time, :string
  end
end
