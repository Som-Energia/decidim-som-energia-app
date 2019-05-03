# frozen_string_literal: true

Decidim::Consultations::ConsultationsHelper.class_eval do
  # Returns a link to the given question with different text/appearence
  # depending on whether the user has voted it or not.
  def display_take_part_button_for(question)
    if current_user && question.voted_by?(current_user)
      i18n_text = t("already_voted", scope: "decidim.questions.vote_button")
      css = "button expanded button--sc success"
    else
      i18n_text = t("take_part", scope: "decidim.consultations.question")
      css = "button expanded button--sc"
    end

    link_to(i18n_text, decidim_consultations.question_path(question), class: css)
  end
end
