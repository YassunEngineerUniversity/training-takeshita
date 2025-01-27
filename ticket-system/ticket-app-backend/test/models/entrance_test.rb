# == Schema Information
#
# Table name: entrances
#
#  id         :integer          not null, primary key
#  name       :string
#  venue_id   :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_entrances_on_venue_id  (venue_id)
#

require "test_helper"

class EntranceTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
