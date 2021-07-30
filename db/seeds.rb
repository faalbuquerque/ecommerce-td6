Category.create!(name: 'Eletrônicos')
Category.create!(name: 'Roupas, Calçados e Acessórios')
Category.create!(name: 'Pet Shop')
product = FactoryBot.create(:product, description: ' Smart TV LED 55" Ultra HD 4K HDR , 
                                                     2 HDMI, 1 USB, Wi-fi',
                                      sku: '2i3enjn', categories: Category.where(name: 'Eletrônicos'),
                                      name: 'TV Treinadev', brand: 'Campus Technology')
product.product_picture.attach(io: File.open("#{Rails.root}/spec/fixtures/files/tv.jpg"), filename: 'tv.jpg', content_type: 'image/jpg')
product.save
Admin.create(email:'admin@mercadores.com.br', password: '123456')
user = User.create(email: 'user1@gmail.com', password: '123456')
user2 = User.create(email: 'user2@gmail.com', password: '123456')

Cart.create(user: user, shipping_id: '1', product: product)
Evaluation.create(user: user, rate: 4, product: product, comment: 'algum comentario')
Evaluation.create(user: user2, rate: 3, product: product, comment: 'algum comentario')
product.update(average_rating: 3.5)

product_one = Product.new(name: 'Bota', brand: 'Campusbota', price: 3.2,
                          description: 'Descrição produto 1', height: '11',
                          width: '22', length: '33', weight: '44',
                          sku: 'a1s2d3f4g5h6', categories: Category.where(name: 'Roupas, Calçados e Acessórios'))
product_one.product_picture.attach(io: File.open("#{Rails.root}/spec/fixtures/files/bota.jpg"), filename: 'bota.jpg', content_type: 'image/jpg')
product_one.save

product_two = Product.new(name: 'Ração Campus Code Peixe Para Gatos Adultos 10,1 kg', brand: 'Campus Code', price: 138.99,
                          description: 'Descrição produto 2', height: '22',
                          width: '44', length: '66', weight: '77',
                          sku: 'h6jk8l9z1c3b', categories: Category.where(name: 'Pet Shop'))
product_two.product_picture.attach(io: File.open("#{Rails.root}/spec/fixtures/files/whiskas.jpg"), filename: 'whiskas.jpg', content_type: 'image/jpg')
product_two.save
