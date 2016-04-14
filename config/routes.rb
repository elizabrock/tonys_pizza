Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # Serve websocket cable requests in-process
  # mount ActionCable.server => '/cable'

  root 'welcome#index'
  resources :customers, except: [:show, :destroy]
  resources :menu_items, except: [:show, :destroy]
  resources :orders, except: [:edit, :update, :destroy]
end
