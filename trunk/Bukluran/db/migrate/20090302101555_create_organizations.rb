class CreateOrganizations < ActiveRecord::Migration
  def self.up
    create_table :organizations do |t|
      t.string :name
      t.string :acronym
      t.date :date_established
      t.text :description
      t.string :tambayan_address
      t.string :nature
      t.string :category
      t.string :mailing_address
      t.string :email_org
      t.string :email_head
      t.boolean :sec_incorporated
      t.date :incorporation_date
      t.string :adviser1
      t.string :adviser2
      t.string :adviser3
      t.boolean :interview
      t.integer :status
      t.date :date_approved
      t.string :college
      t.text :profile
      t.integer :account_id
      
      t.timestamps
    end
  end

  def self.down
    drop_table :organizations
  end
end
