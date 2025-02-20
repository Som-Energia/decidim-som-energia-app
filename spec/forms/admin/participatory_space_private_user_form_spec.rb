# frozen_string_literal: true

require "rails_helper"

module Decidim::Admin
  describe ParticipatorySpacePrivateUserForm do
    subject { described_class.from_params(attributes) }

    let(:email) { "my_email@example.org" }
    let(:name) { "John Wayne" }
    let(:attributes) do
      {
        "participatory_space_private_user" => {
          "email" => email,
          "name" => name,
          "cas_user" => true
        }
      }
    end

    context "when everything is OK" do
      it { is_expected.to be_valid }

      # it "has cas_user attribute" do
      #   expect(subject.cas_user).to be_truthy
      # end
    end

    context "when email is missing" do
      let(:email) { nil }

      it { is_expected.to be_invalid }
    end
  end
end
