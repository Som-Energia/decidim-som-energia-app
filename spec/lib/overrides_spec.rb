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
      "/app/views/decidim/assemblies/_filter_by_type.html.erb" => "c6ddcc8dd42702031f8027bb56b69687"
    }
  },
  {
    package: "decidim-participatory_processes",
    files: {
      "/app/cells/decidim/participatory_processes/process_filters_cell.rb" => "b85676955555828cef0446d918f9722a"
    }
  },
  {
    package: "decidim-proposals",
    files: {
      "/app/controllers/concerns/decidim/proposals/orderable.rb" => "1c19ad9c6f05625a4443f6b0e751c09e",
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
    package: "decidim-consultations",
    files: {
      # not directly manipulated but worth taking a look if anythign changes
      "/app/controllers/decidim/consultations/consultations_controller.rb" => "7b64afa021fcf6e9a924f5217f62179f",
      "/app/controllers/decidim/consultations/questions_controller.rb" => "1b7ec4c7265caccd47f9dc9be08498a9",
      "/app/views/decidim/consultations/consultations/_question.html.erb" => "2d02835e2a1538cd7f6db698e302a29b",
      "/app/helpers/decidim/consultations/consultations_helper.rb" => "c07dd8250d60bcb31231dda864df5d4a",
      "/app/forms/decidim/consultations/admin/question_configuration_form.rb" => "fd988f15b1242e582cc7d0cc8d3d1d2e",
      "/app/commands/decidim/consultations/admin/update_question_configuration.rb" => "e7e60a9437aeaa962b9e089df4f63f1a",
      "/app/views/decidim/consultations/question_multiple_votes/show.html.erb" => "d647ab9bcefd55d9c7b864d1e9c6aead",
      "/app/forms/decidim/consultations/admin/response_form.rb" => "e567a9a49bc702ba630ef7b1cf5f2488",
      "/app/views/decidim/consultations/admin/responses/_form.html.erb" => "6846d66395457acdd7d6ec839a49b0ec",
      "/app/commands/decidim/consultations/admin/create_response.rb" => "557b0dcaa90d5a06196e94a14b800ee3",
      "/app/commands/decidim/consultations/admin/update_response.rb" => "6471a7696cc3bd443a03f69ec578f468",
      "/app/views/decidim/consultations/question_multiple_votes/_form.html.erb" => "af610283ce7ee20f5ef786228a263d4a",
      # modified
      "/app/views/decidim/consultations/admin/question_configuration/_form.html.erb" => "e1ab4e8e5cc988f60f2bfe5e4be0a9f4",
      "/app/views/decidim/consultations/admin/consultations/results.html.erb" => "1a2f7afd79b20b1fcf66bdece660e8ae",
      "/app/views/decidim/consultations/question_multiple_votes/_voting_rules.html.erb" => "9bc6f3b47e2e850ecaf33df56988d437",
      "/app/views/decidim/consultations/questions/show.html.erb" => "a01add938f39d496ca7ae9beee9f6945",
      "/app/views/decidim/consultations/questions/_vote_modal.html.erb" => "bb4b10e9278cffd8d0d4eb57f5197a89",
      "/app/views/decidim/consultations/questions/_results.html.erb" => "2d8196efbf23e2ad7b8c32713c28b240"
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
  # rubocop:disable Rails/DynamicFindBy
  checksums.each do |item|
    spec = ::Gem::Specification.find_by_name(item[:package])

    item[:files].each do |file, signature|
      it "#{spec.gem_dir}#{file} matches checksum" do
        expect(md5("#{spec.gem_dir}#{file}")).to eq(signature)
      end
    end
  end
  # rubocop:enable Rails/DynamicFindBy

  private

  def md5(file)
    Digest::MD5.hexdigest(File.read(file))
  end
end
