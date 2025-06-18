# frozen_string_literal: true

require "rails_helper"

module Decidim
  module Admin
    describe ImportParticipatorySpacePrivateUserCsvJob do
      let!(:email) { "my_user@example.org" }
      let!(:user_name) { "My User Name" }
      let(:user) { create(:user, :admin, organization:) }
      let(:organization) { create(:organization) }
      let(:privatable_to) { create(:participatory_process, organization:) }

      context "when the participatory space private user not exists" do
        it "delegates the work to a command" do
          expect(Decidim::Admin::CreateParticipatorySpacePrivateUser).to receive(:call)
          described_class.perform_now(email, user_name, privatable_to, user)
        end

        it "creates a new participatory private user" do
          expect { described_class.perform_now(email, user_name, privatable_to, user) }.to change(Decidim::ParticipatorySpacePrivateUser, :count).by(1)
          expect(Decidim::ParticipatorySpacePrivateUser.count).to eq 1
          expect(Decidim::ParticipatorySpacePrivateUser.last.cas_user).to be true
        end
      end
    end
  end
end
