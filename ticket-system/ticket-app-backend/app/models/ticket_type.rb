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

class TicketType < ApplicationRecord
  belongs_to :event
  belongs_to :entrance
  has_many :ticket_type_perks
  has_many :perks, through: :ticket_type_perks
  has_many :tickets
  has_many :reservations, through: :tickets
end
