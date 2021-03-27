# frozen_string_literal: true

Rails.application.routes.draw do
  mount Decidim::Core::Engine => "/"
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get "/consultations/:slug/summary", to: "decidim/consultations/consultation_summaries#show", as: "consultation_summary"
  get "/questions/:slug/summary", to: "decidim/consultations/question_summaries#show", as: "question_summary"

  if Rails.env.development?
    get "/consultation_summaries/preview", to: "decidim/consultations/consultation_summaries#preview"
    get "/question_summaries/preview", to: "decidim/consultations/question_summaries#preview"
  end
end
