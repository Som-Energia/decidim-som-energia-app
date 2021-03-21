# frozen_string_literal: true

Rails.application.routes.draw do
  mount Decidim::Core::Engine => "/"
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get "/questions/:slug/summary", to: "decidim/consultations/question_summaries#show", as: "question_summary"
  get "/question_summaries/preview", to: "decidim/consultations/question_summaries#preview" if Rails.env.development?
end
