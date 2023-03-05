require 'rails_helper'

RSpec.describe InvoiceItem, type: :model do
  describe "relationships" do
    it { should belong_to :invoice }
    it { should belong_to :item }
		it { should have_many :bulk_discounts }
  end

  describe 'instance methods' do

    it '#unshipped_items' do
			@merchant = Merchant.create!(name: "Carlos Jenkins") 
			@cust1 = Customer.create!(first_name: "Laura", last_name: "Fiel")
			@cust2 = Customer.create!(first_name: "Bob", last_name: "Fiel")
			@cust3 = Customer.create!(first_name: "John", last_name: "Fiel")
			@cust4 = Customer.create!(first_name: "Tim", last_name: "Fiel")
			@cust5 = Customer.create!(first_name: "Linda", last_name: "Fiel")
			@cust6 = Customer.create!(first_name: "Lucy", last_name: "Fiel")
			@inv1 = @cust1.invoices.create!(status: 1)
			@inv2 = @cust2.invoices.create!(status: 1)
			@inv3 = @cust3.invoices.create!(status: 1)
			@inv4 = @cust4.invoices.create!(status: 1)
			@inv5 = @cust6.invoices.create!(status: 1)
			@inv6 = @cust5.invoices.create!(status: 1)
			
			@bowl = @merchant.items.create!(name: "bowl", description: "it's a bowl", unit_price: 350) 
			@knife = @merchant.items.create!(name: "knife", description: "it's a knife", unit_price: 250) 
			@trans1 = @inv1.transactions.create!(credit_card_number: 5555555555555555, credit_card_expiration_date: nil, result: 0)
			@trans1_5 = @inv1.transactions.create!(credit_card_number: 5555555555555555, credit_card_expiration_date: nil, result: 0)
			@trans2 = @inv2.transactions.create!(credit_card_number: 5555555555555555, credit_card_expiration_date: nil, result: 0)
			@trans3 = @inv2.transactions.create!(credit_card_number: 5555555555555555, credit_card_expiration_date: nil, result: 0)
			@trans4 = @inv3.transactions.create!(credit_card_number: 5555555555555555, credit_card_expiration_date: nil, result: 0)
			@trans5 = @inv3.transactions.create!(credit_card_number: 5555555555555555, credit_card_expiration_date: nil, result: 0)
			@trans6 = @inv3.transactions.create!(credit_card_number: 5555555555555555, credit_card_expiration_date: nil, result: 0)
			@trans7 = @inv4.transactions.create!(credit_card_number: 5555555555555555, credit_card_expiration_date: nil, result: 0)
			@trans8 = @inv4.transactions.create!(credit_card_number: 5555555555555555, credit_card_expiration_date: nil, result: 0)
			@trans9 = @inv4.transactions.create!(credit_card_number: 5555555555555555, credit_card_expiration_date: nil, result: 0)
			@trans10 = @inv4.transactions.create!(credit_card_number: 5555555555555555, credit_card_expiration_date: nil, result: 0)
			@trans11 = @inv5.transactions.create!(credit_card_number: 5555555555555555, credit_card_expiration_date: nil, result: 0)
			@trans12 = @inv5.transactions.create!(credit_card_number: 5555555555555555, credit_card_expiration_date: nil, result: 0)
			@trans13 = @inv5.transactions.create!(credit_card_number: 5555555555555555, credit_card_expiration_date: nil, result: 0)
			@trans14 = @inv5.transactions.create!(credit_card_number: 5555555555555555, credit_card_expiration_date: nil, result: 0)
			@trans15 = @inv5.transactions.create!(credit_card_number: 5555555555555555, credit_card_expiration_date: nil, result: 0)
			@trans16 = @inv6.transactions.create!(credit_card_number: 5555555555555555, credit_card_expiration_date: nil, result: 0)
			
			@invit1 = InvoiceItem.create!(item_id: @bowl.id, invoice_id: @inv1.id, status: 1)
			@invit2 =InvoiceItem.create!(item_id: @bowl.id, invoice_id: @inv2.id, status: 1)
			@invit4 =InvoiceItem.create!(item_id: @knife.id, invoice_id: @inv4.id, status: 0)
			@invit3 =InvoiceItem.create!(item_id: @bowl.id, invoice_id: @inv3.id, status: 1)
			@invit5 =InvoiceItem.create!(item_id: @bowl.id, invoice_id: @inv5.id, status: 0)
			@invit6 =InvoiceItem.create!(item_id: @bowl.id, invoice_id: @inv6.id, status: 2)
		
			expect(InvoiceItem.unshipped_items).to eq([@invit1, @invit2, @invit4, @invit3, @invit5])
			expect(InvoiceItem.unshipped_items).to_not eq([@invit1, @invit2, @invit3, @invit4, @invit5])
			expect(InvoiceItem.unshipped_items).to_not include(@invit6)							
  	end
		
    it 'has_discount' do
			@merchant = Merchant.create!(name: "Carlos Jenkins") 

			@cust1 = Customer.create!(first_name: "Laura", last_name: "Fiel")

			@inv1 = @cust1.invoices.create!(status: 1)

			@bowl = @merchant.items.create!(name: "bowl", description: "it's a bowl", unit_price: 350) 
			@knife = @merchant.items.create!(name: "knife", description: "it's a knife", unit_price: 250)
			@plate = @merchant.items.create!(name: "plate", description: "it's a plate", unit_price: 300)

			@invit1 = InvoiceItem.create!(item_id: @bowl.id, invoice_id: @inv1.id, quantity: 11, unit_price: 350, status: 1)
			@invit2 = InvoiceItem.create!(item_id: @knife.id, invoice_id: @inv1.id, quantity: 16, unit_price: 250, status: 1)
			@invit3 = InvoiceItem.create!(item_id: @plate.id, invoice_id: @inv1.id, quantity: 3, unit_price: 300, status: 1)

			@bulk_discount1 = @merchant.bulk_discounts.create!(percentage_discount: 0.05, quantity_threshold: 10, name: "5off10")
			@bulk_discount2 = @merchant.bulk_discounts.create!(percentage_discount: 0.10, quantity_threshold: 15, name: "10off15")

			expect(@invit1.has_discount).to eq(@bulk_discount1)
			expect(@invit2.has_discount).to eq(@bulk_discount2)
			expect(@invit3.has_discount).to eq(nil)
		end
	end
end
