# frozen_string_literal: true

require "rails_helper"

module Decidim::Consultations::Admin
  describe QuestionConfigurationForm do
    subject { described_class.from_params(attributes) }

    let(:attributes) do
      {
        max_votes: 2,
        min_votes: 1,
        instructions: "Instructions",
        enforce_special_requirements:
      }
    end
    let(:enforce_special_requirements) { false }

    it { is_expected.to be_valid }

    it "has attributes" do
      expect(subject.max_votes).to eq(2)
      expect(subject.min_votes).to eq(1)
      expect(subject.instructions).to eq("Instructions")
      expect(subject.enforce_special_requirements).to be(false)
    end

    context "when enfore_special_requirements is true" do
      let(:enforce_special_requirements) { true }

      it { is_expected.to be_valid }

      it "has attributes" do
        expect(subject.max_votes).to eq(2)
        expect(subject.min_votes).to eq(1)
        expect(subject.instructions).to eq("Instructions")
        expect(subject.enforce_special_requirements).to be(true)
      end
    end
  end
end
