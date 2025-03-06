# frozen_string_literal: true

require "rails_helper"

module Decidim::Admin
  describe ParticipatorySpacePrivateUserCsvImportForm do
    subject do
      described_class.from_params(
        attributes
      ).with_context(
        current_user:,
        current_organization:
      )
    end

    let(:current_organization) { create(:organization) }
    let(:current_user) { create(:user, organization: current_organization) }

    let(:attributes) do
      {
        "file" => file
      }
    end
    let(:file) { Rack::Test::UploadedFile.new(Decidim::Dev.asset("import_participatory_space_private_users.csv"), "text/csv") }

    context "when everything is ok" do
      it { is_expected.to be_valid }
    end

    context "when mail is missing" do
      let(:file) { Rack::Test::UploadedFile.new(Rails.root.join("spec/fixtures/import_participatory_space_users_invalid_email.csv"), "text/csv") }

      it { is_expected.to be_valid }
    end

    context "when email is missing" do
      let(:file) { Rack::Test::UploadedFile.new(Rails.root.join("spec/fixtures/import_participatory_space_users_no_email.csv"), "text/csv") }

      it { is_expected.to be_invalid }

      it "has errors" do
        subject.valid?
        expect(subject.errors[:email]).to eq ["La primera columna ha de contenir emails vàlids!"]
      end
    end

    context "when user is missing" do
      let(:file) { Rack::Test::UploadedFile.new(Rails.root.join("spec/fixtures/import_participatory_space_users_no_user.csv"), "text/csv") }

      it { is_expected.to be_invalid }

      it "has errors" do
        subject.valid?
        expect(subject.errors[:user_name]).to eq ["La segona columna ha de contenir noms!"]
      end
    end

    context "when file is missing" do
      let(:file) { nil }

      it { is_expected.to be_invalid }
    end

    context "when user name contains invalid chars" do
      let(:file) { Rack::Test::UploadedFile.new(Decidim::Dev.asset("import_participatory_space_private_users_nok.csv"), "text/csv") }

      it { is_expected.to be_valid }
    end
  end
end
