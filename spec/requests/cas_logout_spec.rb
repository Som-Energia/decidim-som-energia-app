# frozen_string_literal: true

require "rails_helper"

describe "CAS logout" do # rubocop:disable RSpec/DescribeClass
  include Devise::Test::IntegrationHelpers

  let(:organization) { create(:organization) }
  let!(:user) { create(:user, :confirmed, organization:) }
  let(:cas_logout_url) { "https://cas.example.org/logout" }

  before do
    allow(ENV).to receive(:fetch).and_call_original
    allow(ENV).to receive(:fetch).with("CAS_LOGOUT_URL", nil).and_return(cas_logout_url)
    host! organization.host
    sign_in user
  end

  it "redirects to the CAS logout URL on a different host without raising" do
    delete decidim.destroy_user_session_path

    expect(response).to have_http_status(:redirect)
    expect(response.location).to start_with("#{cas_logout_url}?service=")
  end
end
