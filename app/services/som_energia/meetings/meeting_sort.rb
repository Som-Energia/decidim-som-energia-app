# frozen_string_literal: true

module SomEnergia
  module Meetings
    class MeetingSort
      def initialize(collection)
        @collection = collection
      end

      attr_reader :collection

      def sort
        meetings.reorder(new_order)
      end

      private

      def meetings
        Decidim::Meetings::Meeting.where(id: collection)
      end

      def new_order
        Arel.sql("POSITION(id::text IN '#{sorted_ids.join(",")}')")
      end

      def sorted_ids
        [
          *upcoming_meetings_sorted.ids,
          *past_meetings_sorted.ids
        ]
      end

      def upcoming_meetings_sorted
        meetings.upcoming.order(start_time: :asc)
      end

      def past_meetings_sorted
        meetings.past.order(start_time: :desc)
      end
    end
  end
end
