# == Schema Information
#
# Table name: ticket_type_perks
#
#  id             :integer          not null, primary key
#  ticket_type_id :integer          not null
#  perk_id        :integer          not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_ticket_type_perks_on_perk_id         (perk_id)
#  index_ticket_type_perks_on_ticket_type_id  (ticket_type_id)
#

class TicketTypePerk < ApplicationRecord
  belongs_to :ticket_type
  belongs_to :perk
end
