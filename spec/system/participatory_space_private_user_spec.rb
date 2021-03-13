# frozen_string_literal: true

require "rails_helper"

describe "Admin checks participatory space private users", type: :system do
  let(:organization) { create(:organization) }
  let(:user)         { create(:user, :admin, :confirmed, organization: organization) }
  let(:assembly)     { create(:assembly, organization: organization) }
  let(:setup)        { nil }
  let(:assembly_private_user) do
    user = create :user, organization: organization
    create(:assembly_private_user, user: user, privatable_to: assembly)
  end

  before do
    setup
    switch_to_host(organization.host)
    login_as user, scope: :user
    visit decidim_admin_assemblies.edit_assembly_path(assembly)
    find("a[href*='participatory_space_private_users']").click
  end

  describe "table" do
    let(:setup) do
      assembly_private_user
    end

    it "shows CAS User column" do
      expect(page).to have_selector("th", text: "CAS User")
    end
  end

  describe "invite new participatory space private user" do
    shared_examples "delivered email has correct invitation link" do
      let(:last_email_body) { ActionMailer::Base.deliveries.last.encoded }
      let(:expected_invitation_link) do
        decidim.accept_user_invitation_url(invitation_token: invitation_token, host: organization.host)
      end

      it "proof that we are following the correct invitation link" do
        expect(last_email_body).to have_content(expected_invitation_link)
      end
    end

    shared_examples "following invitation link" do
      before do
        logout :user
        visit accept_invitation_path
      end

      it "has expected path" do
        expect(page).to have_current_path(expected_path)
      end
    end

    class Decidim::User
      private

      def generate_invitation_token
        @raw_invitation_token = "raw_invitation_token"
        self.invitation_token = Devise.token_generator.digest(self, :invitation_token, @raw_invitation_token)
      end
    end

    before do
      find("a[href*='participatory_space_private_users/new']").click
      fill_in :participatory_space_private_user_name,   with: "Whatever"
      fill_in :participatory_space_private_user_email,  with: "what@ever.com"
      fill_cas_user_checkbox
      perform_enqueued_jobs { find("*[type=submit]").click }
    end

    let(:invitation_token) do
      user.send(:generate_invitation_token)
      user.instance_variable_get(:@raw_invitation_token)
    end
    let(:accept_invitation_path) { decidim.accept_user_invitation_path(invitation_token: invitation_token) }

    context "when inviting CAS user" do
      let(:fill_cas_user_checkbox) do
        check :participatory_space_private_user_cas_user
      end

      include_examples "delivered email has correct invitation link"

      include_examples "following invitation link" do
        let(:expected_path) { "/users/cas/sign_in" }
      end
    end

    context "when inviting NON CAS user" do
      let(:fill_cas_user_checkbox) do
        uncheck :participatory_space_private_user_cas_user
      end

      include_examples "delivered email has correct invitation link"

      include_examples "following invitation link" do
        let(:expected_path) { accept_invitation_path }
      end
    end
  end
end
