product = FactoryBot.create(:product, sku: '2i3enjn')
Admin.create(email: 'admin@mercadores.com.br', password: '123456')
user = User.create(email: 'user@mercadores.com.br', password: '123456')
user2 = User.create(email: 'user2@gmail.com', password: '123456')
user.addresses.create!(state: 'SP', city: 'São Paulo', cep: '04543-011',
                       neighborhood: 'Vila Olímpia',
                       street: 'Av. Presidente Juscelino Kubitschek',
                       number: '2041')
# Cart.create(user: user, shipping_id: '1', product: product)
Evaluation.create(user: user2, rate: 3, product: product, comment: 'algum comentario')
product.update(average_rating: 3.5)

product_one = Product.new(name: 'Produto diferente', brand: 'Marca D', price: 3.2,
                          description: 'Descrição produto 1', height: '11',
                          width: '22', length: '33', weight: '44',
                          sku: 'a1s2d3f4g5h6')
product_one.product_picture.attach(io: File.open("#{Rails.root}/spec/fixtures/files/product.jpg"), filename: 'product.jpg', content_type: 'image/png')
product_one.save

product_two = Product.new(name: 'Produto legal', brand: 'Marca 2', price: 5.5,
                          description: 'Descrição produto 2', height: '22',
                          width: '44', length: '66', weight: '77',
                          sku: 'h6jk8l9z1c3b')
product_two.product_picture.attach(io: File.open("#{Rails.root}/spec/fixtures/files/product.jpg"), filename: 'product.jpg', content_type: 'image/png')
product_two.save

FactoryBot.create(:cart, product: product_one, service_order: 'sptogsfesa',
                  delivery_date: 3.days.ago, created_at: 14.days.ago, warehouse_code: '0001', shipping_time: 4, shipping_name: 'Company1', 
       shipping_id: '1', address_id: 1, user_id: 1, status: :delivered)
