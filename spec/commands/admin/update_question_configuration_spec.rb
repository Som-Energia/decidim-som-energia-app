# frozen_string_literal: true

require "rails_helper"

module Decidim::Consultations::Admin
  describe UpdateQuestionConfiguration do
    subject { described_class.new(form, question) }

    let(:question) { create(:question) }
    let(:min_votes) { "3" }
    let(:max_votes) { "5" }
    let(:params) do
      {
        question: {
          id: question.id,
          min_votes:,
          max_votes:,
          instructions_en: "Foo instructions",
          instructions_ca: "Foo instructions",
          instructions_es: "Foo instructions",
          enforce_special_requirements:
        }
      }
    end
    let(:enforce_special_requirements) { true }
    let(:form) { QuestionConfigurationForm.from_params(params) }
    let(:command) { described_class.new(question, form) }

    describe "when the form is valid" do
      it "broadcasts ok" do
        expect { command.call }.to broadcast(:ok)
      end

      it "updates the consultation" do
        command.call
        question.reload

        expect(question.min_votes).to eq(3)
        expect(question.enforce_special_requirements).to be(true)
      end
    end

    context "when special requirements is false" do
      let(:enforce_special_requirements) { false }

      it "updates the consultation" do
        command.call
        question.reload

        expect(question.min_votes).to eq(3)
        expect(question.enforce_special_requirements).to be(false)
      end
    end

    describe "when the form is not valid" do
      before do
        allow(form).to receive(:invalid?).and_return(true)
      end

      it "broadcasts invalid" do
        expect { command.call }.to broadcast(:invalid)
      end

      it "doesn't update the consultation" do
        command.call
        question.reload

        expect(question.min_votes).not_to eq(3)
        expect(question.enforce_special_requirements).to be_nil
      end
    end
  end
end
