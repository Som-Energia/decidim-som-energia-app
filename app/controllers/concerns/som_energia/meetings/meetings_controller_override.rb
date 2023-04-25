# frozen_string_literal: true

module SomEnergia
  module Meetings
    module MeetingsControllerOverride
      extend ActiveSupport::Concern

      included do
        private

        def meetings
          @meetings ||= paginate(ordered_results)
        end

        def ordered_results
          SomEnergia::Meetings::MeetingSort.new(search.results.not_hidden).sort
        end
      end
    end
  end
end
