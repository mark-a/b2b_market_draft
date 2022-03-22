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
      t.integer :company_type
      t.integer :company_size
      t.string :promotion_url
      t.text :about_us
      t.references :company
      t.timestamps
    end


  end
end
