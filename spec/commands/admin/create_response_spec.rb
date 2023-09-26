# frozen_string_literal: true

require "rails_helper"

module Decidim::Consultations::Admin
  describe CreateResponse do
    subject { described_class.new(form) }

    let(:question) { create :question }
    let(:errors) { double.as_null_object }
    let(:validity) { true }
    let(:params) do
      {
        response: {
          title_es: "title"
        }
      }
    end
    let(:context) do
      double(
        current_organization: question.organization,
        current_question: question
      )
    end
    let(:form) do
      double(
        invalid?: !validity,
        title: { en: "title" },
        response_group: nil,
        weight: 3,
        errors: errors,
        context: context
      )
    end

    context "when the form is not valid" do
      let(:validity) { false }

      it "broadcasts invalid" do
        expect { subject.call }.to broadcast(:invalid)
      end
    end

    context "when everything is ok" do
      it "creates a response" do
        expect { subject.call }.to change(Decidim::Consultations::Response, :count).by(1)
        expect(Decidim::Consultations::Response.last.weight).to eq(3)
      end

      it "broadcasts ok" do
        expect { subject.call }.to broadcast(:ok)
      end
    end
  end
end
