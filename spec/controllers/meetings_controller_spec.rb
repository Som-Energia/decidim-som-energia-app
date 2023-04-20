# frozen_string_literal: true

require "rails_helper"

module Decidim::Meetings
  describe MeetingsController, type: :controller do
    routes { Decidim::Meetings::Engine.routes }

    let(:organization) { create(:organization) }
    let(:user) { create(:user, :confirmed, organization: organization) }
    let(:participatory_process) { create(:participatory_process, :with_steps, organization: organization) }

    let(:component) do
      create(:component, manifest_name: "meetings", participatory_space: participatory_process)
    end

    before do
      request.env["decidim.current_organization"] = organization
      request.env["decidim.current_participatory_space"] = participatory_process
      request.env["decidim.current_component"] = component
    end

    it "orders meetings by start_time" do
      # past_meeting = create(:meeting, :published, component: component, start_time: 10.days.ago)
      # recent_meeting = create(:meeting, :published, component: component, start_time: 2.days.ago)
      today_meeting = create(:meeting, :published, component: component)
      next_meeting = create(:meeting, :published, component: component, start_time: 2.days.from_now)
      future_meeting = create(:meeting, :published, component: component, start_time: 10.days.from_now)

      get :index

      expect(controller.helpers.meetings).to eq([today_meeting, next_meeting, future_meeting])
      # expect(controller.helpers.meetings).to eq([today_meeting, next_meeting, future_meeting, recent_meeting, past_meeting])
    end
  end
end
