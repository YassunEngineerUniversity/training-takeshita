# == Schema Information
#
# Table name: comments
#
#  id         :integer          not null, primary key
#  content    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  post_id    :integer          not null
#  user_id    :integer          not null
#
# Indexes
#
#  index_comments_on_post_id  (post_id)
#  index_comments_on_user_id  (user_id)
#
# Foreign Keys
#
#  post_id  (post_id => posts.id)
#  user_id  (user_id => users.id)
#

#   factory :continuous_users, class: User do
#     sequence(:name) { |n| "User #{n}" }
#     sequence(:email) { |n| "user-#{n}@example.com" }
#     password { 'password' }
#     password_confirmation { 'password' }
#   end
# end

FactoryBot.define do
  factory :comment do
    content { Faker::Lorem.sentence }
    user { association :user }
    post { association :post }
  end
end
