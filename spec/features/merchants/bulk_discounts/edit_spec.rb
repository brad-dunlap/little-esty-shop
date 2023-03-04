require 'rails_helper'

RSpec.describe 'Merchant Bulk Discounts Edit' do
	before(:each) do
		Merchant.destroy_all
		BulkDiscount.destroy_all

		@merchant = Merchant.create!(name: "Carlos Jenkins") 
		
		@bulkdisc1 = @merchant.bulk_discounts.create!(percentage_discount: 0.20, quantity_threshold: 5, name: '20 off 5')

		visit "/merchants/#{@merchant.id}/bulk_discounts/#{@bulkdisc1.id}/edit"
	end

	describe 'As a merchant, when I visit my edit merchant bulk discounts page' do
		it "I see that the discounts current attributes are pre-poluated in the form" do
			expect(find_field('Name').value).to eq('20 off 5')
      expect(find_field('Percentage Discount').value).to eq('0.20')
      expect(find_field('Quantity Threshold').value).to eq('5')
    end

		it "When I change any/all of the information and click submit, I am redirected to the bulk discount's show page and I see the attributes have been updated" do
			fill_in :name, with: '40 off 15'
			fill_in :percentage_discount, with: 0.40
			fill_in :quantity_threshold, with: 15

			click_button "Submit"

			expect(current_path).to eq("/merchants/#{@merchant.id}/bulk_discounts")
			expect(page).to have_content("40 off 15")
			expect(page).to have_content("Percentage Discount: 40%")
			expect(page).to have_content("Quantity Threshold: 15")

			expect(page).to_not have_content("Percentage Discount: 20%")
			expect(page).to_not have_content("Quantity Threshold: 5")
    end
	end
end