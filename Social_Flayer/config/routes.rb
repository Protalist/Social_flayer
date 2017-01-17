Rails.application.routes.draw do
  root 'users#home'

  post 'home/change' => 'users#change', as: 'change'
  post 'home/back' => 'users#back', as: 'back'

  resources :stores do  #aggiungiamo routes per stores
	   member do
        post 'chooseyes'=>'stores#choose_yes'
        post 'chooseno'=>'stores#choose_no'
        post 'addadmin' => 'stores#addadmin'
	      put 'like' => 'stores#upvote'
        put 'unlike' => 'stores#downvote'
      end
      resources :products, :except => [:index]
      resources :comments
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
end
