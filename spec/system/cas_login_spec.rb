# frozen_string_literal: true

require "rails_helper"

describe "Login_page" do
  let(:organization) { create(:organization, available_authorizations:) }
  let!(:admin) { create(:user, :admin, :confirmed, email: "admin@example.org", organization:) }
  let(:available_authorizations) { %w(cas_member) }
  let(:omniauth_hash) do
    OmniAuth::AuthHash.new(
      provider: "cas",
      uid: "1234X",
      info: {
        email: "cas@example.org",
        name: "CAS User",
        nickname: "casuser"
      },
      extra: {
        extended_data: extra
      }
    )
  end
  let(:extra) do
    {
      "soci" => 1234,
      "username" => "1234X",
      "member_type" => "member"
    }
  end
  let(:tos_before) { nil }
  let(:last_authorization) { Decidim::Authorization.last }
  let(:last_user) { Decidim::User.last }

  before do
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:cas] = omniauth_hash
    OmniAuth.config.add_camelization "cas", "CAS"
    # OmniAuth.config.request_validation_phase = ->(env) {} if OmniAuth.config.respond_to?(:request_validation_phase)

    allow(ENV).to receive(:[]).and_call_original
    allow(ENV).to receive(:[]).with("AUTO_ACCEPT_TOS_BEFORE").and_return(tos_before)
    switch_to_host(organization.host)
    visit decidim.new_user_session_path
  end

  after do
    OmniAuth.config.test_mode = false
    OmniAuth.config.mock_auth[:cas] = nil
    OmniAuth.config.camelizations.delete("cas")
  end

  it "Admin can login and gets no authorization" do
    expect(page).to have_content "Log in with Som Energia"
    expect(page).to have_content "Administration access"
    expect(page).to have_no_content "Email"
    expect(page).to have_no_content "Password"

    click_on "Administration access"

    expect(page).to have_content "Email"
    expect(page).to have_content "Password"
    fill_in "Email", with: "admin@example.org"
    fill_in "Password", with: "decidim123456789"
    within "#session_new_user" do
      click_on "Log in"
    end
    expect(page).to have_content "Logged in successfully"

    visit decidim.account_path
    expect(page).to have_field("user_email", readonly: false)
    expect(page).to have_content("Change password")
  end

  it "CAS member can login and gets authorized" do
    click_on "Log in with Som Energia"
    check :registration_user_tos_agreement
    within "#omniauth-register-form" do
      click_on "Create an account"
    end

    click_on("Keep unchecked")
    expect(page).to have_content("Successfully")
    expect_user_logged
    expect(Decidim::Identity.where(provider: :cas, uid: "1234X").first.user.newsletter_notifications_at).not_to be_present

    expect(page).to have_content "Successfully authenticated from Cas account."

    expect(last_user).to be_confirmed

    visit decidim.account_path
    expect(page).to have_field("user_email", readonly: true)
    expect(page).to have_no_content("Change password")
  end

  context "when the user exists and has not tos accepted" do
    let!(:user) { create(:user, email: "cas@example.org", accepted_tos_version: nil, organization:) }

    it "CAS member can login and gets authorized" do
      expect { click_on "Log in with Som Energia" }.not_to change(Decidim::User, :count)

      expect(page).to have_content "Successfully authenticated from Cas account."

      expect(user.reload.extended_data).to eq(extra)
      expect(user).to be_confirmed
      expect(user).not_to be_tos_accepted

      expect(last_authorization).not_to be_nil
      expect(last_authorization.name).to eq("cas_member")
      expect(last_authorization.unique_id).to eq("1234X")
      expect(last_authorization.user).to eq(user)
      expect(last_authorization.metadata).to eq(extra)

      click_on "I agree with these terms"
      expect(page).to have_content "You have accepted the terms of service"
      expect(user.reload).to be_tos_accepted

      visit decidim.account_path
      expect(page).to have_field("user_email", readonly: true)
      expect(page).to have_no_content("Change password")
    end
  end

  context "when env AUTO_ACCEPT_TOS_BEFORE is set" do
    let(:tos_before) { 1.day.from_now.to_date.to_s }

    it "CAS member can login and gets authorized and TOS accepted" do
      click_on "Log in with Som Energia"
      check :registration_user_tos_agreement
      within "#omniauth-register-form" do
        click_on "Create an account"
      end
      click_on("Keep unchecked")
      expect(page).to have_content "Successfully authenticated from Cas account."

      expect(last_user).to be_confirmed
      expect(last_user).to be_tos_accepted
    end
  end

  context "when the user has a different email than the one in the CAS response" do
    let!(:user) { create(:user, :confirmed, email: "noncas@example.org", organization:) }
    let!(:identity) { create(:identity, user:, provider: "cas", uid: "1234X") }

    it "updates the user email" do
      expect { click_on "Log in with Som Energia" }.not_to change(Decidim::User, :count)

      expect(page).to have_content "Successfully authenticated from Cas account."

      expect(user.reload.email).to eq("cas@example.org")
      expect(user).to be_confirmed
      expect(user).to be_tos_accepted
    end

    context "when the new email is already taken" do
      let!(:other_user) { create(:user, :confirmed, email: "cas@example.org", organization:) }

      it "does not update the user email" do
        expect { click_on "Log in with Som Energia" }.not_to change(Decidim::User, :count)

        expect(page).to have_content "Successfully authenticated from Cas account."

        expect(user.reload.email).to eq("noncas@example.org")
        expect(user).to be_confirmed
        expect(user).to be_tos_accepted
      end
    end
  end
end
