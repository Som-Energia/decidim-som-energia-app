# frozen_string_literal: true

Decidim::Consultations::ConsultationsHelper.class_eval do
  def decidim_consultations_question_partial
    decidim_gem_dir = Gem::Specification.find_by_name("decidim").gem_dir # rubocop:disable Rails/DynamicFindBy
    view_path = "decidim-consultations/app/views/decidim/consultations/consultations/_question.html.erb"

    "#{decidim_gem_dir}/#{view_path}"
  end
end
