# frozen_string_literal: true

require "rails_helper"

module SomEnergia::Meetings
  describe MeetingSort do
    let(:component) { create(:component, manifest_name: "meetings") }
    let(:upcoming_meeting_one) { create(:meeting, :upcoming, component: component, start_time: 1.year.from_now) }
    let(:upcoming_meeting_two) { create(:meeting, :upcoming, component: component, start_time: 2.years.from_now) }
    let(:past_meeting_one) { create(:meeting, :past, component: component, start_time: 1.year.ago) }
    let(:past_meeting_two) { create(:meeting, :past, component: component, start_time: 2.years.ago) }
    let(:meetings) do
      [
        past_meeting_two,
        upcoming_meeting_two,
        past_meeting_one,
        upcoming_meeting_one
      ]
    end

    describe "#sort" do
      subject { described_class.new(meetings).sort }

      let(:actual_ids) { subject.map(&:id) }
      let(:expected_ids) { expected_meetings.map(&:id) }
      let(:expected_meetings) do
        [
          upcoming_meeting_one,
          upcoming_meeting_two,
          past_meeting_one,
          past_meeting_two
        ]
      end

      it "returns meetings in expected order" do
        expect(actual_ids).to match(expected_ids)
      end
    end
  end
end
