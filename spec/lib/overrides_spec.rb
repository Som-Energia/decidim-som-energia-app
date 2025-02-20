# frozen_string_literal: true

require "rails_helper"

# We make sure that the checksum of the file overriden is the same
# as the expected. If this test fails, it means that the overriden
# file should be updated to match any change/bug fix introduced in the core
checksums = [
  {
    package: "decidim-core",
    files: {
      "/app/controllers/decidim/devise/invitations_controller.rb" => "32ef1da80ec9dd20b884e5829c3307e6",
      "/app/views/layouts/decidim/mailer.html.erb" => "0c7804de08649c8d3c55c117005e51c9"
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
      "/app/cells/decidim/participatory_processes/process_filters_cell.rb" => "cd83acfcd8865c5fe1dbcf8deb5bf319",
      "/app/views/layouts/decidim/_process_navigation.html.erb" => "e4d2322544d80ef4452aa61425034aa3"
    }
  },
  {
    package: "decidim-proposals",
    files: {
      "/app/controllers/concerns/decidim/proposals/orderable.rb" => "536faf3109f8764ff8b2409fd4bf10d0",
      "/app/controllers/decidim/proposals/proposals_controller.rb" => "b263741e3335110fa0e37c488c777190"
    }
  },
  {
    package: "decidim-meetings",
    files: {
      # Meetings natural order, to remove when available as a feature of decidim
      "/app/controllers/decidim/meetings/meetings_controller.rb" => "c4b88c68ea8b5653c6f1e35cd2646011"
    }
  },
  {
    package: "decidim-initiatives",
    files: {
      "/app/controllers/decidim/initiatives/initiatives_controller.rb" => "67166f39d6c05478009d76bc1a38cbdd",
      "/app/mailers/decidim/initiatives/initiatives_mailer.rb" => "a49acd48102c7dea32f842bf40e1a53f",
      "/app/views/decidim/initiatives/initiatives_mailer/notify_creation.html.erb" => "bd034b59170bb4df53856510d2a4bb56",
      "/app/views/decidim/initiatives/initiatives_mailer/notify_state_change.html.erb" => "6472242f33e29183e08c2caefd5d6067"
    }
  },
  {
    package: "decidim-admin",
    files: {

      "/app/jobs/decidim/admin/import_participatory_space_private_user_csv_job.rb" => "753f081b31476451e6c19a020cd20864",
      "/app/commands/decidim/admin/process_participatory_space_private_user_import_csv.rb" => "26d154141af4e77200b842191aa1b619",
      "/app/commands/decidim/admin/create_participatory_space_private_user.rb" => "d0f6bbe7df48393c106019a9155f4ec2",
      "/app/controllers/decidim/admin/concerns/has_private_users_csv_import.rb" => "00f680b822a4025de4f7a9605752976b",
      "/app/forms/decidim/admin/participatory_space_private_user_form.rb" => "3479f27dcc88f98267374490b446b24c",
      "/app/forms/decidim/admin/participatory_space_private_user_csv_import_form.rb" => "45dbe2b22de4e727545b59d749934c3c",
      # views
      "/app/views/decidim/admin/participatory_space_private_users/_form.html.erb" => "be3e6ce2ae14caee518d0def6091c9e0",
      "/app/views/decidim/admin/participatory_space_private_users/index.html.erb" => "4e1759a606da26bdd15596e43ef8cd7e"
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
