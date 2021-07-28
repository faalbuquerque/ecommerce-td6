FactoryBot.create(:product)

Admin.create!(email:'admin@mercadores.com.br', password: '123456')

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
