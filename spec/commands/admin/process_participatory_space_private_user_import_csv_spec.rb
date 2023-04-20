# frozen_string_literal: true

require "rails_helper"

module Decidim::Admin
  describe ProcessParticipatorySpacePrivateUserImportCsv do
    subject { described_class.new(form, current_user, private_users_to) }

    let(:current_user) { create(:user, :admin, organization: organization) }
    let(:organization) { create(:organization) }
    let(:private_users_to) { create :participatory_process, organization: organization }
    let(:file) { File.new Decidim::Dev.asset("import_participatory_space_private_users.csv") }

    let(:form) { ParticipatorySpacePrivateUserCsvImportForm.from_params(attributes) }
    let(:attributes) do
      {
        file: file
      }
    end

    context "when the form is not valid" do
      before do
        allow(form).to receive(:valid?).and_return(false)
      end

      it "broadcasts invalid" do
        expect(subject.call).to broadcast(:invalid, [])
      end

      it "does not enqueue any job" do
        expect(ImportParticipatorySpacePrivateUserCsvJob).not_to receive(:perform_later)

        subject.call
      end
    end

    context "when the CSV file has BOM" do
      let(:file) { File.new Decidim::Dev.asset("import_participatory_space_private_users_with_bom.csv") }
      let(:email) { "my_user@example.org" }

      it "broadcasts ok" do
        expect(subject.call).to broadcast(:ok)
      end

      it "enqueues a job for each present value without BOM" do
        expect(ImportParticipatorySpacePrivateUserCsvJob).to receive(:perform_later).with(email, kind_of(String), private_users_to, current_user)

        subject.call
      end
    end

    it "broadcasts ok" do
      expect(subject.call).to broadcast(:ok)
    end

    it "enqueues a job for each present value" do
      expect(ImportParticipatorySpacePrivateUserCsvJob).to receive(:perform_later).twice.with(kind_of(String), kind_of(String), private_users_to, current_user)

      subject.call
    end

    context "when importing has no emails" do
      let(:file) { File.new File.expand_path(File.join(__dir__, "../fixtures/import_participatory_space_users_no_email.csv")) }

      it "broadcasts invalid" do
        expect(subject.call).to broadcast(:invalid, ["La primera columna ha de contenir emails vàlids!"])
      end

      it "does not enqueue any job" do
        expect(ImportParticipatorySpacePrivateUserCsvJob).not_to receive(:perform_later)

        subject.call
      end
    end

    context "when importing has no users" do
      let(:file) { File.new File.expand_path(File.join(__dir__, "../fixtures/import_participatory_space_users_no_email.csv")) }

      it "broadcasts invalid" do
        expect(subject.call).to broadcast(:invalid, ["La primera columna ha de contenir emails vàlids!"])
      end

      it "does not enqueue any job" do
        expect(ImportParticipatorySpacePrivateUserCsvJob).not_to receive(:perform_later)

        subject.call
      end
    end

    context "when importing invalid emails" do
      let(:file) { File.new File.expand_path(File.join(__dir__, "../fixtures/import_participatory_space_users_invalid_email.csv")) }

      it "broadcasts ok" do
        expect(subject.call).to broadcast(:ok)
      end

      it "enqueues only one job" do
        expect(ImportParticipatorySpacePrivateUserCsvJob).to receive(:perform_later).once.with(kind_of(String), kind_of(String), private_users_to, current_user)

        subject.call
      end
    end

    context "when importing invalid users" do
      let(:file) { File.new Decidim::Dev.asset("import_participatory_space_private_users_nok.csv") }

      it "broadcasts ok" do
        expect(subject.call).to broadcast(:ok)
      end

      it "enqueues all jobs" do
        expect(ImportParticipatorySpacePrivateUserCsvJob).to receive(:perform_later).twice.with(kind_of(String), kind_of(String), private_users_to, current_user)

        subject.call
      end
    end
  end
end
