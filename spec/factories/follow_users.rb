FactoryBot.define do
  factory :one, class: FollowUser do
    follower { 'michael' }
    followee { 'lana' }
  end

  factory :two, class: FollowUser do
    follower { 'michael' }
    followee { 'malory' }
  end

  factory :three, class: FollowUser do
    follower { 'lana' }
    followee { 'michael' }
  end

  factory :four, class: FollowUser do
    follower { 'archer' }
    followee { 'michael' }
  end
end
