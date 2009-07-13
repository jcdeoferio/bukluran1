class CreateEventReports < ActiveRecord::Migration
  def self.up
    create_table :event_reports do |t|
      t.integer :organization_id
      t.string :name
      t.string :category
      t.string :description
      t.date :date
      t.string :venue
      t.string :head
      t.string :file_path1, :file_path2, :file_path3

      t.timestamps
    end
  end

  def self.down
    drop_table :event_reports
  end
end
