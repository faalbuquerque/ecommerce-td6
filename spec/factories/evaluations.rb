FactoryBot.define do
  factory :evaluation do
    user
    product
    rate { 4 }
    comment { 'Comentarios' }
  end
end
