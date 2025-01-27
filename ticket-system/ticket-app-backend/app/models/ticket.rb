# == Schema Information
#
# Table name: tickets
#
#  id             :integer          not null, primary key
#  reservation_id :integer          not null
#  user_id        :integer          not null
#  ticket_type_id :integer          not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_tickets_on_reservation_id  (reservation_id)
#  index_tickets_on_ticket_type_id  (ticket_type_id)
#  index_tickets_on_user_id         (user_id)
#

class Ticket < ApplicationRecord
  belongs_to :reservation
  belongs_to :user
  belongs_to :ticket_type
end
