# frozen_string_literal: true

require "rails_helper"

describe "Admin_adds_CAS_user" do
  let(:organization) { create(:organization) }
  let(:user) { create(:user, :admin, :confirmed, organization:) }
  let(:last_user) { Decidim::User.last }

  before do
    switch_to_host(organization.host)
    login_as user, scope: :user
    visit new_admin_cas_user_path
  end

  it "adds a new CAS user" do
    fill_in "user_name", with: "John Doe"
    fill_in "user_email", with: "test@example.org"
    fill_in "soci", with: "123456"
    fill_in "dni", with: "12345678A"
    click_on "Crea la usuaria"

    expect(page).to have_content("User created successfully")
    expect(last_user.name).to eq("John Doe")
    expect(last_user.email).to eq("test@example.org")
    expect(last_user.extended_data["soci"]).to eq("123456")
    expect(last_user.extended_data["username"]).to eq("12345678A")
    expect(last_user.invitation_sent_at).to be_nil
    expect(last_user).to be_confirmed
  end
end
