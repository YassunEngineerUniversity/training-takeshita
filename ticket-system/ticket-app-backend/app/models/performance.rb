# == Schema Information
#
# Table name: performances
#
#  id          :integer          not null, primary key
#  name        :string
#  promoter_id :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_performances_on_promoter_id  (promoter_id)
#

class Performance < ApplicationRecord
  belongs_to :promoter
end
