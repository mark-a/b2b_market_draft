class AddSearch < ActiveRecord::Migration[7.0]
  def up
    create_table "search_categories" do |t|
      t.string :title
      t.references :parent, null: true, foreign_key: { to_table: 'search_categories' }

      t.timestamps
    end

    create_table "search_criterium_groups" do |t|
      t.string "title", limit: 64
      t.timestamps
    end

    create_table "search_category_memberships" do |t|
      t.references :category, foreign_key: { to_table: 'search_categories' }
      t.references :criterium_group, foreign_key: { to_table: 'search_criterium_groups' }
      t.integer :order
      t.timestamps
    end

    create_table "search_criteria" do |t|
      t.references :category,  foreign_key: { to_table: 'search_categories' }
      t.string "name", limit: 64
      t.string "valuetype", limit: 64
      t.integer "divisor"
      t.integer "min"
      t.integer "max"
      t.timestamps
    end

    create_table "search_purchaser_criteria_matchings" do |t|
      t.references :company,  foreign_key: { to_table: 'companies' }
      t.references :criterium,  foreign_key: { to_table: 'search_criteria' }
      t.integer "values_from"
      t.integer "values_to"
      t.integer "criterium_value_id"
      t.timestamps
    end

    create_table "search_provider_criteria_matchings" do |t|
      t.references :company,  foreign_key: { to_table: 'companies' }
      t.references :criterium,  foreign_key: { to_table: 'search_criteria' }
      t.integer "values_from"
      t.integer "values_to"
      t.integer "criterium_value_id"
      t.timestamps
    end

    create_table "search_criterium_group_memberships" do |t|
      t.references :criterium,  foreign_key: { to_table: 'search_criteria' }
      t.references :criterium_group,  foreign_key: { to_table: 'search_criterium_groups' }, index: { name: :group_membership }
      t.timestamps
    end

    create_table "search_criterium_values" do |t|
      t.references :criterium,  foreign_key: { to_table: 'search_criteria' }
      t.string "title"
      t.timestamps
    end
  end
end
