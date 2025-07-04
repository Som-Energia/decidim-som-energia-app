# frozen_string_literal: true

require "sidekiq/web"
require "sidekiq/cron/web"

Rails.application.routes.draw do
  authenticate :user, ->(u) { u.admin? } do
    mount Sidekiq::Web => "/sidekiq"
  end
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

  namespace :admin do
    resources :iframe, only: [:index]
    resources :cas_users, only: [:new, :create]
  end

  mount Decidim::Core::Engine => "/"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
