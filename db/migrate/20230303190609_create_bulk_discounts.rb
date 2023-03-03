class CreateBulkDiscounts < ActiveRecord::Migration[5.2]
  def change
    create_table :bulk_discounts do |t|
			t.belongs_to :merchant
			t.float :percentage_discount
			t.integer :quantity_threshold
			t.string :name

      t.timestamps
    end
  end
end
