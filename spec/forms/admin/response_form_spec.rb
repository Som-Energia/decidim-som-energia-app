# frozen_string_literal: true

require "rails_helper"

module Decidim::Consultations::Admin
  describe ResponseForm do
    subject { described_class.from_params(attributes) }

    let(:attributes) do
      {
        title_es: "Some title",
        weight: 3
      }
    end

    it "has attributes" do
      expect(subject.title["es"]).to eq("Some title")
      expect(subject.weight).to eq(3)
    end
  end
end
