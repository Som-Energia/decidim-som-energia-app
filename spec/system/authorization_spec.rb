# frozen_string_literal: true

require "rails_helper"

describe "Authorization" do
  let(:organization) { create(:organization, available_authorizations:) }
  let!(:user) { create(:user, :confirmed, email: "admin@example.org", organization:, extended_data:) }
  let(:available_authorizations) { %w(cas_member) }
  let(:extended_data) { {} }

  before do
    switch_to_host(organization.host)
    login_as user, scope: :user
  end

  it "displays the un granted authorization in the users authorization's page" do
    visit decidim_verifications.authorizations_path

    expect(page).to have_content("Som Energia member")
    expect(page).to have_no_content("Granted at")
  end

  context "when authorization is granted" do
    let!(:authorization) { create(:authorization, :granted, user:, name: "cas_member", metadata:) }
    let(:metadata) { { socid: "12345678A", member_type: "member" } }

    it "Shows the member type in the authorization" do
      visit decidim_verifications.authorizations_path

      expect(page).to have_content("Member of Som Energia")
      expect(page).to have_content("Granted at")
    end
  end

  context "when performing a restricted action" do
    let!(:participatory_process) { create(:participatory_process, :with_steps, organization:) }
    let(:proposals_component) { create(:proposal_component, :with_creation_enabled, participatory_space: participatory_process, permissions:) }
    let(:permissions) do
      {
        "create" => {
          "authorization_handlers" => {
            "cas_member" => options
          }
        }
      }
    end
    let(:options) do
      {
        "options" => {
          "member_type" => member_type
        }
      }
    end
    let(:member_type) { "member" }

    before do
      page.visit main_component_path(proposals_component)
    end

    it "prevents access to the action" do
      click_on "New proposal"
      expect(page).to have_content("We need to verify your identity")
      expect(page).to have_content("Verify with Som Energia member")
      click_on "Send"
      expect(page).to have_content("here was a problem creating the authorization")
    end

    context "when the user has extended_data" do
      let(:extended_data) { { "soci" => "12345678A", "username" => "testuser", "member_type" => "member" } }

      it "verifies the user" do
        click_on "New proposal"
        expect(page).to have_content("We need to verify your identity")
        expect(page).to have_content("Verify with Som Energia member")
        click_on "Send"
        expect(page).to have_content("You have been successfully authorized")
      end
    end

    context "when the user is authorized" do
      let!(:authorization) { create(:authorization, :granted, user:, name: "cas_member", metadata:) }
      let(:metadata) { { soci: "12345678A", member_type: user_type } }
      let(:user_type) { "member" }

      it "allows access to the action" do
        click_on "New proposal"
        expect(page).to have_content("Create new proposal")
      end

      context "when the user type does not match" do
        let(:user_type) { "user" }

        it "prevents access to the action" do
          click_on "New proposal"
          expect(page).to have_content("You are not authorized to perform this action")
          expect(page).to have_content("Access for Som Energia members only")
        end
      end

      context "when member_type does not match" do
        let(:member_type) { "user" }

        it "prevents access to the action" do
          click_on "New proposal"
          expect(page).to have_content("You are not authorized to perform this action")
          expect(page).to have_content("Access for Som Energia users (not members) only")
        end
      end

      context "when member_type is any" do
        let(:member_type) { "any" }
        let(:user_type) { "user" }

        it "allows access to the action" do
          click_on "New proposal"
          expect(page).to have_content("New proposal")
        end
      end
    end
  end
end
