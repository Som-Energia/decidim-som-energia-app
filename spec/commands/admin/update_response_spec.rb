# frozen_string_literal: true

require "rails_helper"

module Decidim::Consultations::Admin
  describe UpdateResponse do
    subject { described_class.new(form) }

    let(:errors) { double.as_null_object }
    let(:response) { create(:response) }
    let(:validity) { true }
    let(:context) do
      double(
        current_organization: response.question.organization,
        current_question: response.question
      )
    end
    let(:form) do
      double(
        id: response.id,
        invalid?: !validity,
        title: { en: "New Title" },
        response_group: nil,
        weight: 3,
        errors:,
        context:
      )
    end
    let(:command) { described_class.new(response, form) }

    describe "when the form is valid" do
      it "broadcasts ok" do
        expect { command.call }.to broadcast(:ok)
      end

      it "updates the response" do
        expect(response.title["en"]).not_to eq("New Title")
        expect(response.weight).not_to eq(3)
        expect { command.call }.to broadcast(:ok)
        response.reload

        expect(response.title["en"]).to eq("New Title")
        expect(response.weight).to eq(3)
      end
    end
  end
end
