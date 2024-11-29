FactoryBot.define do
  factory :one, class: Relationship do
    follower { 'michael' }
    followee { 'lana' }
  end

  factory :two, class: Relationship do
    follower { 'michael' }
    followee { 'malory' }
  end

  factory :three, class: Relationship do
    follower { 'lana' }
    followee { 'michael' }
  end

  factory :four, class: Relationship do
    follower { 'archer' }
    followee { 'michael' }
  end
end
