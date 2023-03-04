require 'rails_helper'

RSpec.describe 'Merchant Bulk Disctounts' do
	before(:each) do
		Merchant.destroy_all
		BulkDiscount.destroy_all

		@merchant = Merchant.create!(name: "Carlos Jenkins") 
		
		@bulkdisc1 = @merchant.bulk_discounts.create!(percentage_discount: 0.20, quantity_threshold: 5, name: '20 off 5')
		@bulkdisc2 = @merchant.bulk_discounts.create!(percentage_discount: 0.30, quantity_threshold: 10, name: '30 off 10')

		visit "/merchants/#{@merchant.id}/bulk_discounts/new"
	end

	describe 'As a merchant, when I visit my create(new) merchant bulk discounts page' do
		it 'When I fill in the form with valid data then I am redirected back to the bulk discount index' do

			fill_in :name, with: '40 off 15'
			fill_in :percentage_discount, with: 0.40
			fill_in :quantity_threshold, with: 15

			click_button "Submit"

			expect(current_path).to eq("/merchants/#{@merchant.id}/bulk_discounts")

			visit "/merchants/#{@merchant.id}/bulk_discounts/new"
			fill_in :name, with: '40 off 15'
			fill_in :percentage_discount, with: 400
			fill_in :quantity_threshold, with: 15

			click_button "Submit"
			expect(current_path).to eq("/merchants/#{@merchant.id}/bulk_discounts/new")
			expect(page).to have_content("Discount not created: Please enter discount as a decimal.")
		end

		it 'I see my new bulk discount listed' do
			expect(page).to_not have_content('40 off 15')

			fill_in :name, with: '40 off 15'
			fill_in :percentage_discount, with: 0.40
			fill_in :quantity_threshold, with: 15

			click_button "Submit"

			expect(page).to have_content('40 off 15')
		end
	end
end