# == Schema Information
#
# Table name: perks
#
#  id          :integer          not null, primary key
#  name        :string
#  active      :boolean
#  valid_from  :datetime
#  valid_until :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Perk < ApplicationRecord
  has_many :ticket_type_perks
  has_many :ticket_types, through: :ticket_type_perks
  has_many :perk_usages
  has_many :tickets, through: :perk_usages
end
