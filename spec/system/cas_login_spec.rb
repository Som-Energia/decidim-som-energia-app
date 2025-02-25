# frozen_string_literal: true

require "rails_helper"

describe "Login page", type: :system do
  let(:organization) { create(:organization, available_authorizations: available_authorizations) }
  let!(:admin) { create(:user, :admin, :confirmed, email: "admin@example.org", organization: organization) }
  let(:available_authorizations) { %w(cas_member) }
  let(:omniauth_hash) do
    OmniAuth::AuthHash.new(
      provider: "cas",
      uid: "1234X",
      info: {
        email: "cas@example.org",
        name: "CAS User"
      },
      extra: {
        extended_data: extra
      }
    )
  end
  let(:extra) do
    {
      "soci" => "1234",
      "username" => "1234X",
      "locale" => "ca"
    }
  end
  let(:tos_before) { nil }
  let(:last_authorization) { Decidim::Authorization.last }
  let(:last_user) { Decidim::User.last }

  before do
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:cas] = omniauth_hash
    OmniAuth.config.add_camelization "cas", "CAS"
    OmniAuth.config.request_validation_phase = ->(env) {} if OmniAuth.config.respond_to?(:request_validation_phase)

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
    expect(page).to have_content "Log in as admin"
    expect(page).not_to have_content "Email"
    expect(page).not_to have_content "Password"

    click_button "Log in as admin"

    expect(page).to have_content "Email"
    expect(page).to have_content "Password"
    fill_in "Email", with: "admin@example.org"
    fill_in "Password", with: "decidim123456789"
    click_button "Log in"
    expect(page).to have_content "Signed in successfully"
    expect(last_authorization).to be_nil
  end

  it "CAS member can login and gets authorized" do
    expect { click_link "Log in with Som Energia" }.to change(Decidim::User, :count).by(1)

    expect(page).to have_content "Successfully authenticated from Cas account."

    expect(last_user.extended_data).to eq(extra)
    expect(last_user).to be_confirmed
    expect(last_user).not_to be_tos_accepted

    expect(last_authorization).not_to be_nil
    expect(last_authorization.name).to eq("cas_member")
    expect(last_authorization.unique_id).to eq("1234")
    expect(last_authorization.user).to eq(last_user)
    expect(last_authorization.metadata).to eq(extra)

    click_button "I agree with these terms"
    expect(page).to have_content "You have accepted the terms and conditions"
    expect(last_user.reload).to be_tos_accepted
  end

  context "when the user exists and is not confirmed" do
    let!(:user) { create(:user, email: "cas@example.org", accepted_tos_version: nil, organization: organization) }

    it "CAS member can login and gets authorized" do
      expect { click_link "Log in with Som Energia" }.not_to change(Decidim::User, :count)

      expect(page).to have_content "Successfully authenticated from Cas account."

      expect(user.reload.extended_data).to eq(extra)
      expect(user).to be_confirmed
      expect(user).not_to be_tos_accepted

      expect(last_authorization).not_to be_nil
      expect(last_authorization.name).to eq("cas_member")
      expect(last_authorization.unique_id).to eq("1234")
      expect(last_authorization.user).to eq(user)
      expect(last_authorization.metadata).to eq(extra)

      click_button "I agree with these terms"
      expect(page).to have_content "You have accepted the terms and conditions"
      expect(user.reload).to be_tos_accepted
    end
  end

  context "when env AUTO_ACCEPT_TOS_BEFORE is set" do
    let(:tos_before) { 1.day.from_now.to_date.to_s }

    it "CAS member can login and gets authorized and TOS accepted" do
      expect { click_link "Log in with Som Energia" }.to change(Decidim::User, :count).by(1)

      expect(page).to have_content "Successfully authenticated from Cas account."

      expect(last_user.extended_data).to eq(extra)
      expect(last_user).to be_confirmed
      expect(last_user).to be_tos_accepted

      expect(last_authorization).not_to be_nil
      expect(last_authorization.name).to eq("cas_member")
      expect(last_authorization.unique_id).to eq("1234")
      expect(last_authorization.user).to eq(last_user)
      expect(last_authorization.metadata).to eq(extra)
    end
  end
end
