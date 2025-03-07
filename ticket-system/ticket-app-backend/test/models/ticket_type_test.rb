# == Schema Information
#
# Table name: ticket_types
#
#  id          :integer          not null, primary key
#  name        :string
#  event_id    :integer          not null
#  entrance_id :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_ticket_types_on_entrance_id  (entrance_id)
#  index_ticket_types_on_event_id     (event_id)
#

require "test_helper"

class TicketTypeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
