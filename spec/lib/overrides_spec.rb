# frozen_string_literal: true

require "rails_helper"

# We make sure that the checksum of the file overriden is the same
# as the expected. If this test fails, it means that the overriden
# file should be updated to match any change/bug fix introduced in the core
checksums = [
  {
    package: "decidim-core",
    files: {
      "/app/controllers/decidim/devise/invitations_controller.rb" => "679873eb1166db142625b9ce8283302c",
      "/app/views/layouts/decidim/mailer.html.erb" => "0c7804de08649c8d3c55c117005e51c9"
    }
  },
  {
    package: "decidim-assemblies",
    files: {
      "/app/views/decidim/assemblies/_filter_by_type.html.erb" => "76988d76b84d96079e6d9e1b252a3fda"
    }
  },
  {
    package: "decidim-participatory_processes",
    files: {
      "/app/cells/decidim/participatory_processes/process_filter_cell.rb" => "76988d76b84d96079e6d9e1b252a3fda"
    }
  },
  {
    package: "decidim-proposals",
    files: {
      "/app/controllers/concerns/decidim/proposals/orderable.rb" => "a84b174d775817679beff36349d9d622",
      "/app/controllers/decidim/proposals/proposals_controller.rb" => "81075a969be2732d21f244eff3c4c56e"
    }
  },
  {
    package: "decidim-meetings",
    files: {
      # Meetings natural order, to remove when available as a feature of decidim
      "/app/controllers/decidim/meetings/meetings_controller.rb" => "d0bdba675f1e3df524ac7e834e3a5f37"
    }
  },
  {
    package: "decidim-consultations",
    files: {
      # not directly manipulated but worth taking a look if anythign changes
      "/app/controllers/decidim/consultations/consultations_controller.rb" => "3d75aa7d00721dc3d91aca131d348362",
      "/app/controllers/decidim/consultations/questions_controller.rb" => "1b7ec4c7265caccd47f9dc9be08498a9",
      "/app/views/decidim/consultations/consultations/_question.html.erb" => "21b19519b1f249c27a536fbd1b49d619",
      "/app/helpers/decidim/consultations/consultations_helper.rb" => "bb921ed6da446b9544b81c9f9f9a7574",
      "/app/forms/decidim/consultations/admin/question_configuration_form.rb" => "fd988f15b1242e582cc7d0cc8d3d1d2e",
      "/app/commands/decidim/consultations/admin/update_question_configuration.rb" => "34beed38a9eb629498dca31b59598302",
      "/app/views/decidim/consultations/question_multiple_votes/show.html.erb" => "d647ab9bcefd55d9c7b864d1e9c6aead",
      "/app/forms/decidim/consultations/admin/response_form.rb" => "e567a9a49bc702ba630ef7b1cf5f2488",
      "/app/views/decidim/consultations/admin/responses/_form.html.erb" => "6846d66395457acdd7d6ec839a49b0ec",
      "/app/commands/decidim/consultations/admin/create_response.rb" => "340f0e81855a53a6a03deeea6f07d653",
      "/app/commands/decidim/consultations/admin/update_response.rb" => "5e09376f773c0ac062c77767c872cd41",
      "/app/views/decidim/consultations/question_multiple_votes/_form.html.erb" => "af610283ce7ee20f5ef786228a263d4a",
      # modified
      "/app/views/decidim/consultations/admin/question_configuration/_form.html.erb" => "bca0b383e5eac51414cc5c3347fc8227",
      "/app/views/decidim/consultations/admin/consultations/results.html.erb" => "1a2f7afd79b20b1fcf66bdece660e8ae",
      "/app/views/decidim/consultations/question_multiple_votes/_voting_rules.html.erb" => "207a85b27ee044bd6f5fa79e4ba9dce9",
      "/app/views/decidim/consultations/questions/show.html.erb" => "db9cbbd5933b17bce7ff93b1ff9ddfb7",
      "/app/views/decidim/consultations/questions/_vote_modal.html.erb" => "ae7c38afcc6588a00f8298ea69769da7",
      "/app/views/decidim/consultations/questions/_results.html.erb" => "2d8196efbf23e2ad7b8c32713c28b240"
    }
  },
  {
    package: "decidim-initiatives",
    files: {
      "/app/controllers/decidim/initiatives/initiatives_controller.rb" => "3831df208c134612e97b09aa2bf57026",
      "/app/mailers/decidim/initiatives/initiatives_mailer.rb" => "435a4110f6bc5c8f37eebc36fae4d444",
      "/app/views/decidim/initiatives/initiatives_mailer/notify_creation.html.erb" => "bd034b59170bb4df53856510d2a4bb56",
      "/app/views/decidim/initiatives/initiatives_mailer/notify_state_change.html.erb" => "6472242f33e29183e08c2caefd5d6067"
    }
  },
  {
    package: "decidim-admin",
    files: {

      "/app/jobs/decidim/admin/import_participatory_space_private_user_csv_job.rb" => "753f081b31476451e6c19a020cd20864",
      "/app/commands/decidim/admin/process_participatory_space_private_user_import_csv.rb" => "07cc13617f576263f5a0171581ca9ca4",
      "/app/commands/decidim/admin/create_participatory_space_private_user.rb" => "0a177e0bc25c0110a19bb605a862d56d",
      "/app/controllers/decidim/admin/concerns/has_private_users_csv_import.rb" => "5e6f74f827fc3d0d485cfeec7ecb43e3",
      "/app/forms/decidim/admin/participatory_space_private_user_form.rb" => "3479f27dcc88f98267374490b446b24c",
      "/app/forms/decidim/admin/participatory_space_private_user_csv_import_form.rb" => "084389739c1500bac0606ea779247d11",
      # views
      "/app/views/decidim/admin/participatory_space_private_users/_form.html.erb" => "be3e6ce2ae14caee518d0def6091c9e0",
      "/app/views/decidim/admin/participatory_space_private_users/index.html.erb" => "b008555384e7a237895eb1d368080a0e"
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
