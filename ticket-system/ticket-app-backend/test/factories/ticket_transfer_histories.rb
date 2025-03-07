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

FactoryBot.define do
  factory :ticket_transfer_history do
    ticket { nil }
    from_reservation_id { 1 }
    to_reservation_id { 1 }
    transferred_at { "2025-02-11 16:24:02" }
  end
end
