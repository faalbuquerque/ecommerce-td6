FactoryBot.define do
  factory :admin do
    sequence(:email) { |n| "admin#{n}@mercadores.com.br" }
    password { '123456' }
  end
end
