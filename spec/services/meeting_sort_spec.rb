# frozen_string_literal: true

require "rails_helper"

module SomEnergia::Meetings
  describe MeetingSort do
    let(:component) { create(:component, manifest_name: "meetings") }
    let(:upcoming_meeting_1) { create(:meeting, :upcoming, id: past_meeting_1.id * 10, component: component, start_time: 1.year.from_now) }
    let(:upcoming_meeting_2) { create(:meeting, :upcoming, component: component, start_time: 2.years.from_now) }
    let(:upcoming_meeting_3) { create(:meeting, :upcoming, id: past_meeting_2.id * 10, component: component, start_time: 1.day.ago, end_time: 1.day.from_now) }
    let(:past_meeting_1) { create(:meeting, :past, component: component, start_time: 1.year.ago) }
    let(:past_meeting_2) { create(:meeting, :past, component: component, start_time: 2.years.ago) }
    let(:meetings) do
      [
        past_meeting_2,
        upcoming_meeting_2,
        past_meeting_1,
        upcoming_meeting_3,
        upcoming_meeting_1
      ]
    end

    describe "#sort" do
      subject { described_class.new(meetings).sort }

      let(:actual_ids) { subject.map(&:id) }
      let(:expected_ids) { expected_meetings.map(&:id) }
      let(:expected_meetings) do
        [
          upcoming_meeting_3,
          upcoming_meeting_1,
          upcoming_meeting_2,
          past_meeting_1,
          past_meeting_2
        ]
      end

      it "returns meetings in expected order" do
        expect(actual_ids).to match(expected_ids)
      end
    end
  end
end
