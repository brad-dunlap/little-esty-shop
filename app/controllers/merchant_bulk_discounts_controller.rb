class MerchantBulkDiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:id])
    @bulk_discounts = @merchant.bulk_discounts
  end

	def show
		@merchant = Merchant.find(params[:id])
		@discount = BulkDiscount.find(params[:bulk_discounts_id])
	end

	def new
		@merchant = Merchant.find(params[:id])
	end
	
	def create
		@merchant = Merchant.find(params[:id])
		discount = @merchant.bulk_discounts.new(bulk_discount_params)
		if discount.percentage_discount > 0 && discount.percentage_discount < 1
			if discount.save
				redirect_to "/merchants/#{params[:id]}/bulk_discounts"
			else
				flash[:notice] = "Discount not created: Required information missing."
				redirect_to "/merchants/#{@merchant.id}/bulk_discounts/new"
			end
		else
			flash[:notice] = "Discount not created: Please enter discount as a decimal."
			redirect_to "/merchants/#{@merchant.id}/bulk_discounts/new"
		end
	end

	def edit
		@merchant = Merchant.find(params[:id])
		@discount = BulkDiscount.find(params[:bulk_discounts_id])
	end

	def update
		@merchant = Merchant.find(params[:id])
		@discount = BulkDiscount.find(params[:bulk_discounts_id])
		@discount.update!(bulk_discount_params)
		redirect_to "/merchants/#{params[:id]}/bulk_discounts"
	end

	def destroy
		@merchant = Merchant.find(params[:id])
		@bulk_discount = BulkDiscount.find(params[:bulk_discounts_id])
		@bulk_discount.destroy!
		redirect_to "/merchants/#{params[:id]}/bulk_discounts"	
	end

	private

	def bulk_discount_params
		params.permit(:percentage_discount, :quantity_threshold, :name)
	end
end