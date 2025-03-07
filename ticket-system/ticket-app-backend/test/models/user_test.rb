# == Schema Information
#
# Table name: users
#
#  id                :integer          not null, primary key
#  name              :string
#  email             :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  password_digest   :string
#  admin             :boolean
#  activation_digest :string
#  activated         :boolean
#  activated_at      :datetime
#  remember_digest   :string
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#

require "test_helper"

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
