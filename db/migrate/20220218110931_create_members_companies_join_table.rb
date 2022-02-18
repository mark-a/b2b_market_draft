class CreateMembersCompaniesJoinTable < ActiveRecord::Migration[7.0]
  def change
    create_join_table :companies, :members
  end
end
