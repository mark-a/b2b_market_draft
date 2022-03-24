# frozen_string_literal: true

class AddCompanies < ActiveRecord::Migration[6.0]
  def change
    create_table :companies do |t|
      t.timestamps
    end

    create_table :licences do |t|
      t.string :key
      t.datetime :activated_on, null: true
      t.integer :max_accounts
      t.integer :valid_days
      t.references :company, null: true

      t.timestamps
    end

    create_table :company_profiles do |t|
      t.string :company_name
      t.string :legal_form
      t.text :address
      t.string :phone
      t.string :contact_email
      t.string :contact_web
      t.text :about_us
      t.text :bg_color_hex
      t.references :company
      t.timestamps
    end


  end
end
