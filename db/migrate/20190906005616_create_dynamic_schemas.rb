class CreateDynamicSchemas < ActiveRecord::Migration[5.1]
  def change
    create_table :dynamic_schemas do |t|
      t.string :m3_class
      t.references :m3_context, foreign_key: true
      t.references :m3_profile, foreign_key: true
      t.text :schema

      t.timestamps
    end
  end
end