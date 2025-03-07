# == Schema Information
#
# Table name: ticket_transfer_histories
#
#  id                  :integer          not null, primary key
#  ticket_id           :integer          not null
#  from_reservation_id :integer
#  to_reservation_id   :integer
#  transferred_at      :datetime
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
# Indexes
#
#  index_ticket_transfer_histories_on_ticket_id  (ticket_id)
#

require "test_helper"

class TicketTransferHistoryTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
