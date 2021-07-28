product = FactoryBot.create(:product)
Admin.create(email:'admin@mercadores.com.br', password: '123456')
user = User.create(email: 'user1@gmail.com', password: '123456')
Cart.create(user: user, shipping_id: '1', product: product)
