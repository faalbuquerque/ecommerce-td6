FactoryBot.define do
  factory :category do
    sequence(:name) { |n| "category#{n}" }
    status { 0 }
  end
end
