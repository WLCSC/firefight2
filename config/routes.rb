Firefight2::Application.routes.draw do
  get "audit/" => "audit#index", :as => 'audit'

  get "report" => 'report#index'

  get "report/submissions"
  get "report/comments"
  post "report/submissions_graph"
  get "report/submissions_graph"
  post "report/comments_graph"
  get "report/comments_graph"

  resources :alerts

  resources :consumables do
      get 'order', :on => :collection
  end
	resources :inventories do
		member do
			get 'adj'
			post 'use'
		end
	end

	resources :photos
	resources :departments
	resources :shortcuts do
		collection do
			get 'quick'
			post 'sort'
		end
	end

	resources :ticketqueues
	resources :comments
	get "home/index"

	get "home/tools"

	post "sessions/create"

	post 'tags/destroy'

	resources :permissions

	resources :groups do
		post 'change', :on => :member
	end

	resources :manufacturers do
		resources :models
	end
	resources :buildings
	resources :loans do
		member do
			post 'approve'
			post 'return'
		end
        collection do
            post 'assign'
            get 'quick'
        end
	end
	resources :maps
	resources :tickets do
		member do
			match 'tagchange'
			get 'untag'
			get 'tag'
			get 'assign'
			get 'unassign'
		end
		collection do
			post 'mass'
            post 'csv'
			get 'screenshot'
		end
	end

	resources :rooms
	resources :users do
        member do
            get 'tickets_for'
        end
    end
	resources :rtypes
	resources :models
	resources :assets do
		collection do
			post 'quick'
			post 'move'
			post 'mass'
		end
	end
	resources :vendors
	resources :tags
	get "principals/index"

	get "principals/edit"

	get "principals/update"

	get "principals/destroy"

	get "sessions/new", :as => 'new_session'

	get "sessions/create"

	get "sessions/destroy"

	# The priority is based upon order of creation:
	# first created -> highest priority.

	# Sample of regular route:
	#   match 'products/:id' => 'catalog#view'
	# Keep in mind you can assign values other than :controller and :action

	# Sample of named route:
	#   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
	# This route can be invoked with purchase_url(:id => product.id)

	# Sample resource route (maps HTTP verbs to controller actions automatically):
	#   resources :products

	# Sample resource route with options:
	#   resources :products do
	#     member do
	#       get 'short'
	#       post 'toggle'
	#     end
	#
	#     collection do
	#       get 'sold'
	#     end
	#   end

	# Sample resource route with sub-resources:
	#   resources :products do
	#     resources :comments, :sales
	#     resource :seller
	#   end

	# Sample resource route with more complex sub-resources
	#   resources :products do
	#     resources :comments
	#     resources :sales do
	#       get 'recent', :on => :collection
	#     end
	#   end

	# Sample resource route within a namespace:
	#   namespace :admin do
	#     # Directs /admin/products/* to Admin::ProductsController
	#     # (app/controllers/admin/products_controller.rb)
	#     resources :products
	#   end

	# You can have the root of your site routed with "root"
	# just remember to delete public/index.html.
	root :to => 'home#index'

	# See how all your routes lay out with "rake routes"

	# This is a legacy wild controller route that's not recommended for RESTful applications.
	# Note: This route will make all actions in every controller accessible via GET requests.
	# match ':controller(/:action(/:id))(.:format)'
end
