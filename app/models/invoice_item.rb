class InvoiceItem < ApplicationRecord
  belongs_to :invoice
  belongs_to :item
	has_many :bulk_discounts, through: :item
	

  enum status: ['pending', 'packaged', 'shipped']

  def self.unshipped_items
    where(status: 'pending').or(where(status: 'packaged')).order(:created_at)
  end

	def has_discount
		self.bulk_discounts
		.where('quantity_threshold <= ?', self.quantity)
		.order(percentage_discount: :desc)
		.first
	end
end
