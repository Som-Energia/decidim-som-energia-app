# frozen_string_literal: true

require "rails_helper"

# We make sure that the checksum of the file overriden is the same
# as the expected. If this test fails, it means that the overriden
# file should be updated to match any change/bug fix introduced in the core
checksums = [
  {
    package: "decidim-core",
    files: {
      "/app/controllers/decidim/devise/sessions_controller.rb" => "7cecc389de97bf63f17da505d6c05774",
      "/app/controllers/decidim/devise/registrations_controller.rb" => "3b9d431d19e456aeab3eb861b6189bf4",
      "/app/views/decidim/account/show.html.erb" => "1c230c5c6bc02e0bb22e1ea92b0da96c",
      "/app/views/decidim/devise/sessions/new.html.erb" => "da0d18178c8dcead2774956e989527c5",
      "/app/views/decidim/devise/shared/_omniauth_buttons.html.erb" => "688a13e36af349a91e37b04c6caaa3a9",
      "/app/views/decidim/shared/_login_modal.html.erb" => "98bd2832be207d7abcd48d2a0ba40bd0",
      "/app/cells/decidim/authorization_modal_cell.rb" => "c7c1d02f217c3885e38de513839bf92e",
      "/app/cells/decidim/data_consent/dialog.erb" => "a997a919ebc462605e842012d365d77a"
    }
  },
  {
    package: "decidim-verifications",
    files: {
      "/app/helpers/decidim/verifications/application_helper.rb" => "9f40fba8f2f7f16d588b8bcad4300376"
    }
  }
]

describe "Overriden files", type: :view do
  checksums.each do |item|
    spec = Gem::Specification.find_by_name(item[:package])

    item[:files].each do |file, signature|
      it "#{spec.gem_dir}#{file} matches checksum" do
        expect(md5("#{spec.gem_dir}#{file}")).to eq(signature)
      end
    end
  end

  private

  def md5(file)
    Digest::MD5.hexdigest(File.read(file))
  end
end
