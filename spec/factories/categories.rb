FactoryBot.define do
  factory :category do
    sequence(:name) { |n| "category#{n}" }
    status { 1 }
    subcategory_id { nil }
  end
end
