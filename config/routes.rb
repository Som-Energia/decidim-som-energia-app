# frozen_string_literal: true

require "sidekiq/web"
require "sidekiq/cron/web"

Rails.application.routes.draw do
  authenticate :user, ->(u) { u.admin? } do
    mount Sidekiq::Web => "/sidekiq"
  end
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

  # manual logout via GET petition
  devise_scope :user do
    get "/logout", to: "decidim/devise/sessions#destroy", as: :logout
  end

  namespace :admin do
    resources :iframe, only: [:index]
  end

  mount Decidim::Core::Engine => "/"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get "/consultations/:slug/summary", to: "decidim/consultations/consultation_summaries#show", as: "consultation_summary"
  get "/questions/:slug/summary", to: "decidim/consultations/question_summaries#show", as: "question_summary"

  if Rails.env.development?
    get "/consultation_summaries/preview", to: "decidim/consultations/consultation_summaries#preview"
    get "/question_summaries/preview", to: "decidim/consultations/question_summaries#preview"
  end

  # recreates the /assemblies route for /any-alternative, reusing the same controllers
  # content will be differentiatied automatically by scoping selectively all SQL queries depending on the URL prefix
  if Rails.application.secrets.alternative_assembly_types
    Rails.application.secrets.alternative_assembly_types.each do |item|
      resources item[:key], only: [:index, :show], param: :slug, path: item[:key], controller: "decidim/assemblies/assemblies" do
        resources :assembly_members, only: :index, path: "members"
        resource :assembly_widget, only: :show, path: "embed"
      end

      scope "/#{item[:key]}/:assembly_slug/f/:component_id" do
        Decidim.component_manifests.each do |manifest|
          next unless manifest.engine

          constraints Decidim::Assemblies::CurrentComponent.new(manifest) do
            mount manifest.engine, at: "/", as: "decidim_assembly_#{manifest.name}"
          end
        end
      end
    end
  end

  # recreates the /processes route for /any-alternative, reusing the same controllers
  # content will be differentiatied automatically by scoping selectively all SQL queries depending on the URL prefix
  if Rails.application.secrets.scoped_participatory_process_slug_prefixes
    Rails.application.secrets.scoped_participatory_process_slug_prefixes.each do |item|
      resources item[:key], only: [:index, :show], param: :slug, path: item[:key], controller: "decidim/participatory_processes/participatory_processes" do
        get "all-metrics", on: :member
        resources :participatory_process_steps, only: [:index], path: "steps"
        resource :widget, only: :show, path: "embed"
      end

      scope "/#{item[:key]}/:participatory_process_slug/f/:component_id" do
        Decidim.component_manifests.each do |manifest|
          next unless manifest.engine

          constraints Decidim::ParticipatoryProcesses::CurrentComponent.new(manifest) do
            mount manifest.engine, at: "/", as: "decidim_participatory_process_#{manifest.name}"
          end
        end
      end
    end
  end
end
