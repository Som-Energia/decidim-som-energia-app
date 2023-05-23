# frozen_string_literal: true

Decidim::ReportingProposals.configure do |config|
  # Public Setting that defines after how many days a not-answered proposal is overdue
  # Set it to 0 (zero) if you don't want to use this feature
  config.unanswered_proposals_overdue = 0

  # Public Setting that defines after how many days an evaluating-state proposal is overdue
  # Set it to 0 (zero) if you don't want to use this feature
  config.evaluating_proposals_overdue = 0

  # Public Setting that defines whether the administrator is allowed to hide the proposals.
  # Set to false if you do not want to use this feature
  config.allow_admins_to_hide_proposals = true

  # Public Setting that adds a button next to the "add image" input[type=file] to open the camera directly
  config.use_camera_button = [:proposals, :reporting_proposals]

  # Public Setting to prevent adding the camera button on not photo/image input[type=file]
  config.camera_button_on_attachments = false

  # Public setting to prevent valuators or admins to modify the photos attached to a proposal
  # otherwise can be configured at the component level
  config.allow_proposal_photo_editing = true

  # Public setting to allow to assign other valuators
  config.valuators_assign_other_valuators = true
end
