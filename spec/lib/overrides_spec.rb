# frozen_string_literal: true

require "rails_helper"

# We make sure that the checksum of the file overriden is the same
# as the expected. If this test fails, it means that the overriden
# file should be updated to match any change/bug fix introduced in the core
checksums = [
  {
    package: "decidim-core",
    files: {
      "/app/controllers/decidim/devise/invitations_controller.rb" => "0cbb345ec888627a3a66cce00aba2c25",
      "/app/views/layouts/decidim/mailer.html.erb" => "4e308c82acd8b1dac405ff71963d8743",
      "/app/commands/decidim/create_omniauth_registration.rb" => "ba4a490a4addf1a369874fa7e104748d",
      "/app/views/decidim/account/show.html.erb" => "567f47fd001a0222943579d9ebfe5f3a",
      "/app/views/decidim/devise/sessions/new.html.erb" => "9d090fc9e565ded80a9330d4e36e495c",
      "/app/views/decidim/devise/shared/_omniauth_buttons.html.erb" => "a456549c8f521b012ec7436d9e7111f4",
      "/app/views/decidim/devise/shared/_omniauth_buttons_mini.html.erb" => "d3a413ce7c64959eee3b912406075f84"
    }
  },
  {
    package: "decidim-assemblies",
    files: {
      "/app/views/decidim/assemblies/_filter_by_type.html.erb" => "c6ddcc8dd42702031f8027bb56b69687",
      "/app/views/layouts/decidim/_assembly_navigation.html.erb" => "159f168bf1634937183cf5ca56b03a9d"
    }
  },
  {
    package: "decidim-participatory_processes",
    files: {
      "/app/cells/decidim/participatory_processes/process_filters_cell.rb" => "37a8ead748188734c8f253c350eab34d"
    }
  },
  {
    package: "decidim-proposals",
    files: {
      "/app/controllers/concerns/decidim/proposals/orderable.rb" => "a40bf56a26b5f26f5d51f8e7387a3c67",
      "/app/controllers/decidim/proposals/proposals_controller.rb" => "d718411feb73de820e36c729dc198bd8"
    }
  },
  {
    package: "decidim-meetings",
    files: {
      # Meetings natural order, to remove when available as a feature of decidim
      "/app/controllers/decidim/meetings/meetings_controller.rb" => "b5cb5d2f044b30d348f891f56f851a02"
    }
  },
  {
    package: "decidim-initiatives",
    files: {
      "/app/controllers/decidim/initiatives/initiatives_controller.rb" => "d3304742ef313be67e873da0074259ce",
      "/app/mailers/decidim/initiatives/initiatives_mailer.rb" => "a49acd48102c7dea32f842bf40e1a53f",
      "/app/views/decidim/initiatives/initiatives_mailer/notify_creation.html.erb" => "df0eeccf28b84fc55bcf93410308d38d",
      "/app/views/decidim/initiatives/initiatives_mailer/notify_state_change.html.erb" => "6472242f33e29183e08c2caefd5d6067"
    }
  },
  {
    package: "decidim-admin",
    files: {

      "/app/jobs/decidim/admin/import_participatory_space_private_user_csv_job.rb" => "bd3c600bb488db10a3aeac3941b2cb26",
      "/app/commands/decidim/admin/process_participatory_space_private_user_import_csv.rb" => "4e290b826af84d7cedebb1e6e9526f5b",
      "/app/commands/decidim/admin/create_participatory_space_private_user.rb" => "5c354131b4bcd3deb74780595091c502",
      "/app/controllers/decidim/admin/concerns/has_private_users_csv_import.rb" => "45d947412c056a07ef695a115bac1b82",
      "/app/forms/decidim/admin/participatory_space_private_user_form.rb" => "3479f27dcc88f98267374490b446b24c",
      "/app/forms/decidim/admin/participatory_space_private_user_csv_import_form.rb" => "372bff11067a454e0bb4e51b3a93213b",
      # views
      "/app/views/decidim/admin/participatory_space_private_users/_form.html.erb" => "d4a044267fa1f4c261bdc65b3fa198df",
      "/app/views/decidim/admin/participatory_space_private_users/index.html.erb" => "93e081c00098fc9e2cc2c23792ad68e2"
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
