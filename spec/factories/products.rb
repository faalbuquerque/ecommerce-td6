include Rack::Test::Methods
include ActionDispatch::TestProcess::FixtureFile

FactoryBot.define do
  factory :product do
    product_picture { Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/product.jpg'), 'product_picture.jpg') }
    sequence(:name) { |n| "Produto #{n}" }
    sequence(:description) { |n| "Uma descrição sobre alguma coisa #{n}" }
    sequence(:sku) { |n| "123#{n}ABC" }
    price { 20 } # { rand(10..100) }
    length { 0.3 }
    width { 0.2 }
    height { 0.4 }
    weight { 0.4 }
    brand { 'Marca X' }
  end
end
