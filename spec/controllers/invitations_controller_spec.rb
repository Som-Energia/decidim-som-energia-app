# frozen_string_literal: true

require "rails_helper"

module Decidim::Devise
  describe InvitationsController do
    routes { Decidim::Core::Engine.routes }

    let(:organization) { create(:organization) }
    let(:inviter) { create(:user, :admin, organization:) }
    let(:invitation_params) do
      {
        organization:,
        name: "Invited User",
        email: "inviteduser@example.org"
      }
    end
    let!(:user) { Decidim::User.invite!(invitation_params, inviter) }

    before do
      request.env["decidim.current_organization"] = organization
      request.env["devise.mapping"] = ::Devise.mappings[:user]
    end

    describe "accepting invitation" do
      let(:password) { "decidim123456789" }
      let(:registration_params) do
        {
          invitation_token: user.raw_invitation_token,
          nickname: "invited_user",
          password:,
          password_confirmation: password
        }
      end

      it "responds to the edit path" do
        get :edit, params: { invitation_token: user.raw_invitation_token }
        expect(response).to have_http_status(:ok)
      end

      it "redirects to the provided path" do
        post :update, params: { user: registration_params }
        expect(response).to redirect_to("/")
      end
    end

    # describe "accepting invitation with CAS user" do
    #   let(:password) { "decidim123456789" }
    #   let(:registration_params) do
    #     {
    #       invitation_token: user.raw_invitation_token,
    #       nickname: "invited_user",
    #       password:,
    #       password_confirmation: password
    #     }
    #   end
    describe "accepting invitation with CAS user" do
      let(:password) { "decidim123456789" }
      let(:registration_params) do
        {
          invitation_token: user.raw_invitation_token,
          nickname: "invited_user",
          password:,
          password_confirmation: password
        }
      end

      before do
        create(:participatory_space_private_user, user:, cas_user: true)
      end

      it "redirects to the CAS login path" do
        get :edit, params: { invitation_token: user.raw_invitation_token }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
