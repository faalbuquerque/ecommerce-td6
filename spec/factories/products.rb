FactoryBot.define do
  factory :product do
    product_picture do
      Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/product.jpg'), 'product_picture.jpg')
    end
    sequence(:name) { |n| "Produto #{n}" }
    sequence(:description) { |n| "Uma descrição sobre alguma coisa #{n}" }
    sequence(:sku) { |n| "123#{n}ABC" }
    price { 20 }
    length { 0.3 }
    width { 0.2 }
    height { 0.4 }
    weight { 0.4 }
    sequence(:brand) { |n| "Marca X#{n}" }
  end
end
