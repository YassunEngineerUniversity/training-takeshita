FactoryBot.define do
  factory :post do
    content { Faker::Lorem.sentence }
  end

  factory :orange, class: Post do
    content { 'I just ate an orange!' }
    created_at { 10.minutes.ago }
    association :user, factory: :michael
  end

  factory :tau_manifesto, class: Post do
    content { 'Check out the @tauday site by @mhartl: https://tauday.com' }
    created_at { 3.years.ago }
    association :user, factory: :michael
  end

  factory :cat_video, class: Post do
    content { 'Sad cats are sad: https://youtu.be/PKffm2uI4dk' }
    created_at { 2.hours.ago }
    association :user, factory: :michael
  end

  factory :most_recent, class: Post do
    content { 'Writing a short test' }
    created_at { Time.zone.now }
    user
    association :user, factory: :michael
  end

  factory :ants, class: Post do
    content { 'Oh, is that what you want? Because that\'s how you get ants!' }
    created_at { 2.years.ago }
    association :user, factory: :archer
  end

  factory :zone, class: Post do
    content { 'Danger zone!' }
    created_at { 3.days.ago }
    association :user, factory: :archer
  end

  factory :tone, class: Post do
    content { "I'm sorry. Your words made sense, but your sarcastic tone did not." }
    created_at { 10.minutes.ago }
    association :user, factory: :lana
  end

  # Add a sequence for generating multiple posts
  factory :random_post, class: Post do
    content { Faker::Lorem.sentence(word_count: 5) }
    created_at { 42.days.ago }
    association :user, factory: :michael
  end
end
