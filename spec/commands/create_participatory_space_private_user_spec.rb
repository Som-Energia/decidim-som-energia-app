# frozen_string_literal: true

require "rails_helper"

module Decidim::Admin
  describe CreateParticipatorySpacePrivateUser do
    subject { described_class.new(form, current_user, privatable_to, via_csv:) }

    let(:via_csv) { false }
    let(:privatable_to) { create(:participatory_process) }
    let!(:email) { "my_email@example.org" }
    let!(:name) { "Weird Guy" }
    let!(:user) { create(:user, email: "my_email@example.org", organization: privatable_to.organization) }
    let!(:current_user) { create(:user, email: "some_email@example.org", organization: privatable_to.organization) }
    let(:cas_user) { true }
    let(:form) do
      double(
        invalid?: invalid,
        email:,
        name:,
        cas_user:
      )
    end
    let(:invalid) { false }

    it "creates the private user" do
      participatory_space_private_users = Decidim::ParticipatorySpacePrivateUser.where(user:)
      expect { subject.call }.to change { participatory_space_private_users.count }.by(1)

      expect(participatory_space_private_users.count).to eq 1
      expect(participatory_space_private_users.first.cas_user).to be_truthy
    end

    context "when the form is not valid" do
      let(:invalid) { true }

      it "is not valid" do
        expect { subject.call }.to broadcast(:invalid)
      end
    end

    context "when no cas_user" do
      let(:cas_user) { false }

      it "creates the private user" do
        subject.call

        expect(Decidim::ParticipatorySpacePrivateUser.count).to eq 1
        expect(Decidim::ParticipatorySpacePrivateUser.last.cas_user).to be_falsey
      end
    end
  end
end
