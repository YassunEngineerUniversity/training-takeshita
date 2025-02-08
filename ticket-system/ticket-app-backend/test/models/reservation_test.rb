# == Schema Information
#
# Table name: reservations
#
#  id               :integer          not null, primary key
#  user_id          :integer          not null
#  ticket_agency_id :integer          not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_reservations_on_ticket_agency_id  (ticket_agency_id)
#  index_reservations_on_user_id           (user_id)
#

require "test_helper"

class ReservationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
