Refinery::Core::Engine.routes.append do

  # Admin routes
  namespace :dropbox_accounts, :path => '' do
    namespace :admin, :path => 'refinery' do
      resources :dropbox_accounts, :except => [:show, :update, :create, :edit] do
        collection do
          post :update_positions
          get  :callback,         :as => :callback
        end
      end
    end
  end

end
