require 'rails_helper'

describe 'User view order' do
  let(:cart) do
    create(:cart, product: product, user: user, address: address, shipping_id: 3,
                  shipping_name: 'Frete 1', shipping_price: 15, service_order: 'SOWUXRR4p6',
                  shipping_time: 10, delivery_date: 1.day.from_now, warehouse_code: 'CD34')
  end

  it 'successfully' do
    user = create(:user)
    address = create(:address, user: user)
    product = create(:product, name: 'Produto 1', sku: '1234abc')
    create(:cart, product: product, user: user, address: address, service_order: 'SOWUXRR4p6')

    login_as user, scope: :user
    visit root_path
    click_on 'Meus Pedidos'

    expect(page).to have_content('Produto 1')
  end
  it 'create' do
    user = create(:user, email: 'jhondoe@user.com')
    address = create(:address, user: user, street: 'Rua Padre Vieira', city: 'Campinas',
                               state: 'SP', cep: '13015301', neighborhood: 'Centro', number: '880')
    product = create(:product, name: 'Produto 1', brand: 'Marca do Produto 1',
                               description: 'Descrição sobre este produto',
                               price: 20, height: '2', width: '1',
                               length: '3', weight: '4', sku: '1234abc')
    cart = create(:cart, product: product, user: user, address: address, shipping_id: 3,
                         shipping_name: 'Frete 1', shipping_price: 15, service_order: 'SOWUXRR4p6',
                         shipping_time: 10, delivery_date: 1.day.from_now, warehouse_code: 'CD34')
    vol = product.height * product.width * product.length
    attributes = { sku: product.sku, volume: vol, weight: product.weight }
    customer = { lat: -22.9054968, lon: -47.0538185, state: 'SP' }
    find_stock_product(sku: product.sku, status: 200)
    find_shippings(attributes: attributes, customer: customer, status: 200)
    stock_address_mock(code: 'CD34', status: 200)
    selling_conclusion(cart: cart, stock_address: 'Alameda Santos, 1293, Jardim Paulista, São Paulo/SP', address: address, status: 200)
    notifying_stock(cart: cart, service_order: 'SOGEfKG2cv', status: 200)
    cart.destroy

    login_as user, scope: :user
    visit root_path
    click_on 'Produto 1'
    fill_in 'Endereço', with: '800 Rua Padre Vieira - Centro, Campinas - São Paulo'
    click_on 'Estimar Frete'
    click_on 'Adicionar ao carrinho'
    choose('Rua Padre Vieira - 880 - Centro - Campinas - SP - 13015301')
    click_on 'Calcular valor de entrega'
    choose('Frete 1 - Preço: R$ 15,00 - Prazo de entrega: 10 dias úteis')
    click_on 'Finalizar Compra'

    expect(page).to have_content('Pedido realizado com sucesso!')
    expect(page).to have_content('Produto 1')
    expect(page).to have_content('R$ 20,00')
    expect(page).to have_content('13015301')
    expect(page).to have_content('jhondoe@user.com')
  end
  it 'without select address' do
    user = create(:user, email: 'jhondoe@user.com')
    address = create(:address, user: user, street: 'Rua Padre Vieira', city: 'Campinas',
                               state: 'SP', cep: '13015301', neighborhood: 'Centro', number: '880')
    product = create(:product, name: 'Produto 1', sku: '1234abc')
    vol = product.height * product.width * product.length
    attributes = { sku: product.sku, volume: vol, weight: product.weight }
    customer = { lat: -22.9054968, lon: -47.0538185, state: 'SP' }
    create(:cart, product: product, user: user, address: address, shipping_id: 3,
                  shipping_name: 'Frete 1', shipping_price: 15, service_order: 'SOWUXRR4p6',
                  shipping_time: 10, delivery_date: 1.day.from_now, warehouse_code: 'CD34')
    find_stock_product(sku: product.sku, status: 200)
    find_shippings(attributes: attributes, customer: customer, status: 200)

    login_as user, scope: :user
    visit users_carts_path
    click_on 'Calcular valor de entrega'

    expect(page).to have_content('Selecione um endereço')
  end
  it 'without select shipping' do
    user = create(:user, email: 'jhondoe@user.com')
    address = create(:address, user: user, street: 'Rua Padre Vieira', city: 'Campinas',
                               state: 'SP', cep: '13015301', neighborhood: 'Centro', number: '880')
    product = create(:product, name: 'Produto 1', sku: '1234abc')
    vol = product.height * product.width * product.length
    attributes = { sku: product.sku, volume: vol, weight: product.weight }
    customer = { lat: -22.9054968, lon: -47.0538185, state: 'SP' }
    create(:cart, product: product, user: user, address: address, shipping_id: 3,
                  shipping_name: 'Frete 1', shipping_price: 15, service_order: 'SOWUXRR4p6',
                  shipping_time: 10, delivery_date: 1.day.from_now, warehouse_code: 'CD34')
    find_stock_product(sku: product.sku, status: 200)
    find_shippings(attributes: attributes, customer: customer, status: 200)

    login_as user, scope: :user
    visit users_carts_path
    choose('Rua Padre Vieira - 880 - Centro - Campinas - SP - 13015301')
    click_on 'Calcular valor de entrega'
    click_on 'Finalizar Compra'

    expect(page).to have_content('Obrigatório escolher o frete para adicionar ao carrinho')
  end
  context 'failure stock_address' do
    it 'status not 200' do
      user = create(:user, email: 'jhondoe@user.com')
      address = create(:address, user: user, street: 'Rua Padre Vieira', city: 'Campinas',
                               state: 'SP', cep: '13015301', neighborhood: 'Centro', number: '880')
      product = create(:product, name: 'Produto 1', sku: '1234abc')
      vol = product.height * product.width * product.length
      attributes = { sku: product.sku, volume: vol, weight: product.weight }
      customer = { lat: -22.9054968, lon: -47.0538185, state: 'SP' }
      create(:cart, product: product, user: user, address: address, shipping_id: 3,
                    shipping_name: 'Frete 1', shipping_price: 15, service_order: 'SOWUXRR4p6',
                    shipping_time: 10, delivery_date: 1.day.from_now, warehouse_code: 'CD34')
      find_stock_product(sku: product.sku, status: 200)
      find_shippings(attributes: attributes, customer: customer, status: 200)
      stock_address_mock(code: 'CD34', status: 500)

      login_as user, scope: :user
      visit users_carts_path
      choose('Rua Padre Vieira - 880 - Centro - Campinas - SP - 13015301')
      click_on 'Calcular valor de entrega'
      choose('Frete 1 - Preço: R$ 15,00 - Prazo de entrega: 10 dias úteis')
      click_on 'Finalizar Compra'

      expect(page).to have_content('Não foi possível concluir a compra, frete indisponível')
    end
    it 'failure connection' do
      user = create(:user, email: 'jhondoe@user.com')
      address = create(:address, user: user, street: 'Rua Padre Vieira', city: 'Campinas',
                                 state: 'SP', cep: '13015301', neighborhood: 'Centro', number: '880')
      product = create(:product, name: 'Produto 1', sku: '1234abc')
      vol = product.height * product.width * product.length
      attributes = { sku: product.sku, volume: vol, weight: product.weight }
      customer = { lat: -22.9054968, lon: -47.0538185, state: 'SP' }
      create(:cart, product: product, user: user, address: address, shipping_id: 3,
                    shipping_name: 'Frete 1', shipping_price: 15, service_order: 'SOWUXRR4p6',
                    shipping_time: 10, delivery_date: 1.day.from_now, warehouse_code: 'CD34')
      find_stock_product(sku: product.sku, status: 200)
      find_shippings(attributes: attributes, customer: customer, status: 200)
      failure_stock_address(code: 'CD34')

      login_as user, scope: :user
      visit users_carts_path
      choose('Rua Padre Vieira - 880 - Centro - Campinas - SP - 13015301')
      click_on 'Calcular valor de entrega'
      choose('Frete 1 - Preço: R$ 15,00 - Prazo de entrega: 10 dias úteis')
      click_on 'Finalizar Compra'

      expect(page).to have_content('Não foi possível concluir a compra, frete indisponível')
    end
  end
  context 'failure shipping_conclusion' do
    it 'status not 200' do
      user = create(:user, email: 'jhondoe@user.com')
      address = create(:address, user: user, street: 'Rua Padre Vieira', city: 'Campinas',
                                 state: 'SP', cep: '13015301', neighborhood: 'Centro', number: '880')
      product = create(:product, name: 'Produto 1', sku: '1234abc')
      vol = product.height * product.width * product.length
      attributes = { sku: product.sku, volume: vol, weight: product.weight }
      customer = { lat: -22.9054968, lon: -47.0538185, state: 'SP' }
      cart = create(:cart, product: product, user: user, address: address, shipping_id: 3,
                           shipping_name: 'Frete 1', shipping_price: 15, service_order: 'SOWUXRR4p6',
                           shipping_time: 10, delivery_date: 1.day.from_now, warehouse_code: 'CD34')
      find_stock_product(sku: product.sku, status: 200)
      find_shippings(attributes: attributes, customer: customer, status: 200)
      stock_address_mock(code: 'CD34', status: 200)
      selling_conclusion(cart: cart, stock_address: 'Alameda Santos, 1293, Jardim Paulista, São Paulo/SP', address: address, status: 500)

      login_as user, scope: :user
      visit users_carts_path
      choose('Rua Padre Vieira - 880 - Centro - Campinas - SP - 13015301')
      click_on 'Calcular valor de entrega'
      choose('Frete 1 - Preço: R$ 15,00 - Prazo de entrega: 10 dias úteis')
      click_on 'Finalizar Compra'

      expect(page).to have_content('Não foi possível concluir a compra, frete indisponível')
    end
    it 'failure connection' do
      user = create(:user, email: 'jhondoe@user.com')
      address = create(:address, user: user, street: 'Rua Padre Vieira', city: 'Campinas',
                                 state: 'SP', cep: '13015301', neighborhood: 'Centro', number: '880')
      product = create(:product, name: 'Produto 1', sku: '1234abc')
      vol = product.height * product.width * product.length
      attributes = { sku: product.sku, volume: vol, weight: product.weight }
      customer = { lat: -22.9054968, lon: -47.0538185, state: 'SP' }
      cart = create(:cart, product: product, user: user, address: address, shipping_id: 3,
                           shipping_name: 'Frete 1', shipping_price: 15, service_order: 'SOWUXRR4p6',
                           shipping_time: 10, delivery_date: 1.day.from_now, warehouse_code: 'CD34')
      find_stock_product(sku: product.sku, status: 200)
      find_shippings(attributes: attributes, customer: customer, status: 200)
      stock_address_mock(code: 'CD34', status: 200)
      failure_selling_conclusion(cart: cart, stock_address: 'Alameda Santos, 1293, Jardim Paulista, São Paulo/SP', address: address)

      login_as user, scope: :user
      visit users_carts_path
      choose('Rua Padre Vieira - 880 - Centro - Campinas - SP - 13015301')
      click_on 'Calcular valor de entrega'
      choose('Frete 1 - Preço: R$ 15,00 - Prazo de entrega: 10 dias úteis')
      click_on 'Finalizar Compra'

      expect(page).to have_content('Não foi possível concluir a compra, frete indisponível')
    end
  end
  context 'failure stock reservation' do
    it 'status not 200' do
      user = create(:user, email: 'jhondoe@user.com')
      address = create(:address, user: user, street: 'Rua Padre Vieira', city: 'Campinas',
                                 state: 'SP', cep: '13015301', neighborhood: 'Centro', number: '880')
      product = create(:product, name: 'Produto 1', sku: '1234abc')
      vol = product.height * product.width * product.length
      attributes = { sku: product.sku, volume: vol, weight: product.weight }
      customer = { lat: -22.9054968, lon: -47.0538185, state: 'SP' }
      cart = create(:cart, product: product, user: user, address: address, shipping_id: 3,
                           shipping_name: 'Frete 1', shipping_price: 15, service_order: 'SOWUXRR4p6',
                           shipping_time: 10, delivery_date: 1.day.from_now, warehouse_code: 'CD34')
      find_stock_product(sku: product.sku, status: 200)
      find_shippings(attributes: attributes, customer: customer, status: 200)
      stock_address_mock(code: 'CD34', status: 200)
      selling_conclusion(cart: cart, stock_address: 'Alameda Santos, 1293, Jardim Paulista, São Paulo/SP', address: address, status: 200)
      notifying_stock(cart: cart, service_order: 'SOGEfKG2cv', status: 500)

      login_as user, scope: :user
      visit users_carts_path
      choose('Rua Padre Vieira - 880 - Centro - Campinas - SP - 13015301')
      click_on 'Calcular valor de entrega'
      choose('Frete 1 - Preço: R$ 15,00 - Prazo de entrega: 10 dias úteis')
      click_on 'Finalizar Compra'

      expect(page).to have_content('Não foi possível concluir a compra, frete indisponível')
    end
    it 'failure connection' do
      user = create(:user, email: 'jhondoe@user.com')
      address = create(:address, user: user, street: 'Rua Padre Vieira', city: 'Campinas',
                                 state: 'SP', cep: '13015301', neighborhood: 'Centro', number: '880')
      product = create(:product, name: 'Produto 1', sku: '1234abc')
      vol = product.height * product.width * product.length
      attributes = { sku: product.sku, volume: vol, weight: product.weight }
      customer = { lat: -22.9054968, lon: -47.0538185, state: 'SP' }
      cart = create(:cart, product: product, user: user, address: address, shipping_id: 3,
                           shipping_name: 'Frete 1', shipping_price: 15, service_order: 'SOWUXRR4p6',
                           shipping_time: 10, delivery_date: 1.day.from_now, warehouse_code: 'CD34')
      find_stock_product(sku: product.sku, status: 200)
      find_shippings(attributes: attributes, customer: customer, status: 200)
      stock_address_mock(code: 'CD34', status: 200)
      selling_conclusion(cart: cart, stock_address: 'Alameda Santos, 1293, Jardim Paulista, São Paulo/SP', address: address, status: 200)
      failure_notifying_stock(cart: cart, service_order: 'SOGEfKG2cv')

      login_as user, scope: :user
      visit users_carts_path
      choose('Rua Padre Vieira - 880 - Centro - Campinas - SP - 13015301')
      click_on 'Calcular valor de entrega'
      choose('Frete 1 - Preço: R$ 15,00 - Prazo de entrega: 10 dias úteis')
      click_on 'Finalizar Compra'

      expect(page).to have_content('Não foi possível concluir a compra, frete indisponível')
    end
  end
end
