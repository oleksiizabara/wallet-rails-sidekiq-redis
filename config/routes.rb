# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations',
                                    sessions: 'users/sessions' }
  root to: 'users#home'
  resources :users do
  end
  get 'home', to: 'users#home', as: 'home'
  get 'money_transfers', to: 'wallets#money_transfers', as: 'money_transfers'
  post 'confirm_transaction/:id', to: 'wallet_transactions#confirm_transaction', as: 'confirm_transaction'
  resources :wallets
  resources :invites
  resources :wallet_transactions

  get :documentation, to: 'users#documentation', as: 'documentation'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
