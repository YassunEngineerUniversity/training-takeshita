FactoryBot.define do
  factory :post do
    content { Faker::Lorem.sentence }
  end
end
