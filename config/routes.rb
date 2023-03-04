Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  root 'welcome#index'
  get "/admin", to: 'admin#index'

	resources :merchants, only: [:edit, :update, :new, :create] do
		member do 
			get 'dashboard'
		end

    resources :invoices, only: [:show, :update]
	end

  namespace :admin do
    resources :invoices, only: [:index, :show, :update]
    resources :merchants, only: [:index, :show]
  end

  get "/merchants/:id/bulk_discounts", to: "merchant_bulk_discounts#index"
  get "/merchants/:id/bulk_discounts/new", to: "merchant_bulk_discounts#new"
  post "/merchants/:id/bulk_discounts", to: "merchant_bulk_discounts#create"
  get "/merchants/:id/bulk_discounts/:bulk_discounts_id", to: "merchant_bulk_discounts#show"
  patch "/merchants/:id/bulk_discounts/:bulk_discounts_id", to: "merchant_bulk_discounts#update"
  get "/merchants/:id/bulk_discounts/:bulk_discounts_id/edit", to: "merchant_bulk_discounts#edit"
  delete "/merchants/:id/bulk_discounts/:bulk_discounts_id", to: "merchant_bulk_discounts#destroy"
	
	get "/merchants/:id/invoices", to: "merchant_invoices#index"
	
  get "/merchants/:id/items", to: "merchant_items#index"
  get "/merchants/:merchant_id/items/new", to: "merchant_items#new"
  post "/merchants/:merchant_id/items", to: "merchant_items#create"
  get "/merchants/:merchant_id/items/:item_id", to: "merchant_items#show"
  get "/merchants/:merchant_id/items/:item_id/edit", to: "merchant_items#edit"
  patch "/merchants/:merchant_id/items/:item_id", to: "merchant_items#update"
end
