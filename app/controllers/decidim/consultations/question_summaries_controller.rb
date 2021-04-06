# frozen_string_literal: true

module Decidim
  module Consultations
    class QuestionSummariesController < Decidim::Consultations::QuestionsController
      def show
        enforce_permission_to :read, :question, question: current_question

        render layout: "layouts/decidim/question_summary"
      end

      def preview
        @question = OrganizationQuestions.for(current_organization).sample

        render layout: false
      end
    end
  end
end
