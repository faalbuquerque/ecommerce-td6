FactoryBot.define do
  factory :return do
    cart
    user
    status { 0 }
  end
end
