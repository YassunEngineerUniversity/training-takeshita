# == Schema Information
#
# Table name: likes
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  post_id    :integer          not null
#  user_id    :integer          not null
#
# Indexes
#
#  index_likes_on_post_id                 (post_id)
#  index_likes_on_post_id_and_created_at  (post_id,created_at)
#  index_likes_on_user_id                 (user_id)
#  index_likes_on_user_id_and_created_at  (user_id,created_at)
#
# Foreign Keys
#
#  post_id  (post_id => posts.id)
#  user_id  (user_id => users.id)
#
class Like < ApplicationRecord
  belongs_to :user
  belongs_to :post
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :post_id, presence: true
end
