class Invoice < ApplicationRecord
  belongs_to :customer
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :transactions
	has_many :merchants, through: :items
	has_many :bulk_discounts, through: :merchants
  
  enum status: ["in progress", "completed", "cancelled"]

  def self.incomplete_invoices
    joins(:invoice_items).where({status: 0, "invoice_items.status": [0, 1]}).distinct.order(:created_at)
  end

  def total_revenue
    invoice_items.sum('unit_price * quantity')
  end

	def total_invoice_discount
		x = invoice_items.joins(item: {merchant: :bulk_discounts})
    .where('invoice_items.quantity >= bulk_discounts.quantity_threshold')
    .group('invoice_items.id')
    .select('MAX((invoice_items.quantity * invoice_items.unit_price) * bulk_discounts.percentage_discount / 100) AS discount_amt')

		x.sum(&:discount_amt)
	end

	def merchant_total_revenue_with_discount
		total_revenue - total_invoice_discount
	end
end