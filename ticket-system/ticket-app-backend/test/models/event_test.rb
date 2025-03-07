# == Schema Information
#
# Table name: events
#
#  id             :integer          not null, primary key
#  name           :string
#  performance_id :integer          not null
#  venue_id       :integer          not null
#  start_time     :datetime
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  end_time       :datetime
#
# Indexes
#
#  index_events_on_performance_id  (performance_id)
#  index_events_on_venue_id        (venue_id)
#

require "test_helper"

class EventTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
