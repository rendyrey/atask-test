# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  namespace :api do
    namespace :v1 do
      scope :accounts do
        get "/" => "account#get"
        post "create" => "account#create"
        get "balance" => "account#account_balance"
        get "wallets" => "account#account_wallets"
      end

      post "login" => "authentication#login"

      scope :transaction do
        post "top-up" => "transaction#top_up"
        post "withdraw" => "transaction#withdraw"
        post "transfer" => "transaction#transfer"
      end
    end
  end
end
