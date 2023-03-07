require 'rails_helper'

RSpec.describe 'Merchant Bulk Discounts' do
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
		visit "/merchants/#{@merchant.id}/bulk_discounts"
	end

	describe 'As a merchant, when I visit my merchant bulk discounts index page' do
		it 'I  see all of my bulk discounts including their percentage discount and quantity thresholds' do

			within "#bulk_discounts" do
				expect(page).to have_content("20 off 5")
				expect(page).to have_content("30 off 10")
			end
			
			within "#bulk_discount_#{@bulkdisc1.id}" do
				expect(page).to have_content("Percentage Discount: 20%")
				expect(page).to have_content("Quantity Threshold: 5")
				expect(page).to_not have_content("Quantity Threshold: 10")
			end

			within "#bulk_discount_#{@bulkdisc2.id}" do
				expect(page).to have_content("Percentage Discount: 30%")
				expect(page).to have_content("Quantity Threshold: 10")
				expect(page).to_not have_content("Percentage Discount: 20%")
			end
		end

		it 'each bulk discount listed includes a link to its show page' do
			within "#bulk_discounts" do
				expect(page).to have_link("20 off 5", href: "/merchants/#{@merchant.id}/bulk_discounts/#{@bulkdisc1.id}")
				expect(page).to have_link("30 off 10", href: "/merchants/#{@merchant.id}/bulk_discounts/#{@bulkdisc2.id}")
			end
		end

		it 'has a link to create a new discount' do
			expect(page).to have_link("Create New Discount")
		end

		it 'when I click this link I am taken to a page to add a new bulk discount' do
			click_link("Create New Discount")
			expect(current_path).to eq("/merchants/#{@merchant.id}/bulk_discounts/new")
		end


		it 'next to each bulk discount I see a link to delete it' do
			within "#bulk_discount_#{@bulkdisc1.id}" do 
				expect(page).to have_link("Delete")
			end

			within "#bulk_discount_#{@bulkdisc2.id}" do 
				expect(page).to have_link("Delete")
			end
		end

		it 'When I click the delete link I am redirected back to the bulk discounts index page where I no longer see the discount listed' do
			within "#bulk_discount_#{@bulkdisc1.id}" do 
				click_link "Delete"
			end
		
			expect(current_path).to eq("/merchants/#{@merchant.id}/bulk_discounts")
		
			within "#bulk_discounts" do
				expect(page).to_not have_content("20 off 5")
				expect(page).to have_content("30 off 10")
			end

			within "#bulk_discount_#{@bulkdisc2.id}" do 
				click_link "Delete"
			end

			expect(current_path).to eq("/merchants/#{@merchant.id}/bulk_discounts")

			within "#bulk_discounts" do
				expect(page).to_not have_content("20 off 5")
				expect(page).to_not have_content("30 off 10")
			end
		end

		it 'I see a section with a header of "Upcoming Holidays"' do
			save_and_open_page
			within "#holidays" do
				expect(page).to have_content("Upcoming Holidays")
				expect(page).to have_content("Good Friday - 2023-04-07")
				expect(page).to have_content("Memorial Day - 2023-05-29")
				expect(page).to have_content("Juneteenth - 2023-06-19")
			end			
		end
	end
end