require 'rails_helper'

RSpec.describe 'Merchant Bulk Discounts Show' do
	before(:each) do
		Merchant.destroy_all
		Customer.destroy_all
		Invoice.destroy_all
		Item.destroy_all
		Transaction.destroy_all
		InvoiceItem.destroy_all
		BulkDiscount.destroy_all
		@merchant = Merchant.create!(name: "Carlos Jenkins") 
		
		@bulkdisc1 = @merchant.bulk_discounts.create!(percentage_discount: 0.20, quantity_threshold: 5, name: '20 off 5')
		@bulkdisc2 = @merchant.bulk_discounts.create!(percentage_discount: 0.30, quantity_threshold: 10, name: '30 off 10')
		visit "/merchants/#{@merchant.id}/bulk_discounts/#{@bulkdisc1.id}"
	end
	
	describe 'As a merchant, when I visit my merchant bulk discounts Show page' do
		it 'I see the bulk discounts quantity threshold and percentage discount' do

			expect(page).to have_content("Percentage Discount: 20%")
			expect(page).to have_content("Quantity Threshold: 5")

			visit "/merchants/#{@merchant.id}/bulk_discounts/#{@bulkdisc2.id}"
			expect(page).to have_content("Percentage Discount: 30%")
			expect(page).to have_content("Quantity Threshold: 10")
		end
	
		it 'I see a link to edit the bulk discount' do
			expect(page).to have_link("Edit Discount")
		end

		it "when I click this link I am taken to a new page with a form to edit the discount" do
			click_link("Edit Discount")
			expect(current_path).to eq("/merchants/#{@merchant.id}/bulk_discounts/#{@bulkdisc1.id}/edit")
		end
	end
end