# == Schema Information
#
# Table name: perk_usages
#
#  id         :integer          not null, primary key
#  ticket_id  :integer          not null
#  perk_id    :integer          not null
#  used_at    :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_perk_usages_on_perk_id    (perk_id)
#  index_perk_usages_on_ticket_id  (ticket_id)
#

class PerkUsage < ApplicationRecord
  belongs_to :ticket
  belongs_to :perk
end
