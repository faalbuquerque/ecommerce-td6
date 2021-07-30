require 'rails_helper'

describe 'User view order' do
  it 'successfully' do
    user = create(:user)
    address = create(:address, user: user)
    product = create(:product, name: 'Produto 1')
    create(:cart, product: product, user: user, address: address)

    login_as user, scope: :user
    visit root_path
    click_on 'Meus Pedidos'

    expect(page).to have_content('Produto 1')
  end

  it 'create' do
    user = create(:user, email: 'jhondoe@user.com')
    create(:address, user: user, street: 'Rua Padre Vieira', city: 'Campinas', state: 'SP',
                     cep: '13015301', neighborhood: 'Centro', number: '880')
    product = create(:product, name: 'Produto 1', brand: 'Marca do Produto 1',
                               description: 'Descrição sobre este produto',
                               price: 20, height: '2', width: '1',
                               length: '3', weight: '4', sku: 'woeife3483ru')
    vol = product.height * product.width * product.length
    attributes = { sku: product.sku, volume: vol, weight: product.weight }
    custumer = { lat: -22.9054968, lon: -47.0538185, state: 'SP' }

    shippings_json = File.read(Rails.root.join('spec/fixtures/shippings.json'))
    stock_json = File.read(Rails.root.join('spec/fixtures/product_stock.json'))

    find_stock_product(product.sku, stock_json)
    find_shippings(attributes, shippings_json, custumer)

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
    create(:address, user: user, street: 'Rua Padre Vieira', city: 'Campinas', state: 'SP',
                     cep: '13015301', neighborhood: 'Centro', number: '880')
    product = create(:product, price: 20, name: 'Produto 1')
    vol = product.height * product.width * product.length
    attributes = { sku: product.sku, volume: vol, weight: product.weight }
    custumer = { lat: -22.9054968, lon: -47.0538185, state: 'SP' }

    shippings_json = File.read(Rails.root.join('spec/fixtures/shippings.json'))
    stock_json = File.read(Rails.root.join('spec/fixtures/product_stock.json'))

    find_stock_product(product.sku, stock_json)
    find_shippings(attributes, shippings_json, custumer)

    login_as user, scope: :user
    visit root_path
    click_on 'Produto 1'
    fill_in 'Endereço', with: '800 Rua Padre Vieira - Centro, Campinas - São Paulo'
    click_on 'Estimar Frete'
    click_on 'Adicionar ao carrinho'
    click_on 'Calcular valor de entrega'

    expect(page).to have_content('Selecione um endereço')
  end

  it 'without select address' do
    user = create(:user, email: 'jhondoe@user.com')
    create(:address, user: user, street: 'Rua Padre Vieira', city: 'Campinas', state: 'SP',
                     cep: '13015301', neighborhood: 'Centro', number: '880')
    product = create(:product, price: 20, name: 'Produto 1')
    vol = product.height * product.width * product.length
    attributes = { sku: product.sku, volume: vol, weight: product.weight }
    custumer = { lat: -22.9054968, lon: -47.0538185, state: 'SP' }

    shippings_json = File.read(Rails.root.join('spec/fixtures/shippings.json'))
    stock_json = File.read(Rails.root.join('spec/fixtures/product_stock.json'))

    find_stock_product(product.sku, stock_json)
    find_shippings(attributes, shippings_json, custumer)

    login_as user, scope: :user
    visit root_path
    click_on 'Produto 1'
    fill_in 'Endereço', with: '800 Rua Padre Vieira - Centro, Campinas - São Paulo'
    click_on 'Estimar Frete'

    click_on 'Adicionar ao carrinho'
    choose('Rua Padre Vieira - 880 - Centro - Campinas - SP - 13015301')
    click_on 'Calcular valor de entrega'
    click_on 'Finalizar Compra'

    expect(page).to have_content('Selecione o frete')
  end
end
