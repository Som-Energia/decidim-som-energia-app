# frozen_string_literal: true

require "rails_helper"

module Decidim::Devise
  describe RegistrationsController do
    routes { Decidim::Core::Engine.routes }

    let(:organization) { create(:organization) }
    let(:email) { "test@example.org" }

    before do
      request.env["devise.mapping"] = ::Devise.mappings[:user]
      request.env["decidim.current_organization"] = organization
    end

    describe "GET new" do
      it "redirects to login" do
        get :new
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe "POST create" do
      let(:params) do
        {
          user: {
            sign_up_as: "user",
            name: "User",
            nickname: "nickname",
            email:,
            password: "rPYWYKQJrXm97b4ytswc",
            password_confirmation: "rPYWYKQJrXm97b4ytswc",
            tos_agreement: "1",
            newsletter: "0"
          }
        }
      end

      it "redirects to login" do
        post(:create, params:)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
