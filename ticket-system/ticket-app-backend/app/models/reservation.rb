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

class Reservation < ApplicationRecord
  belongs_to :user
  belongs_to :ticket_agency
  has_many :tickets
  has_many :ticket_transfer_histories, through: :tickets
end
