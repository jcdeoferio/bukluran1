class CreateOrganizations < ActiveRecord::Migration
  def self.up
    create_table :organizations do |t|
      t.integer :account_id
      t.string :name, :acronym, :nature, :category, :status, :approved_by
      t.string :mailing_address, :email_org, :email_head
      t.date :date_established, :date_incorporation, :date_approved
      t.text :description, :comment
      t.boolean :sec_incorporated, :interviewed

      t.string :adviser1_name, :adviser1_dept, :adviser1_position 
      t.string :adviser1_mobile, :adviser1_home, :adviser1_office, :adviser1_email
      
      t.string :adviser2_name, :adviser2_dept, :adviser2_position 
      t.string :adviser2_mobile, :adviser2_home, :adviser2_office, :adviser2_email
      
      t.string :adviser3_name, :adviser3_dept, :adviser3_position 
      t.string :adviser3_mobile, :adviser3_home, :adviser3_office, :adviser3_email
      
      t.boolean :editable
      
      t.timestamps
    end
  end

  def self.down
    drop_table :organizations
  end
end
