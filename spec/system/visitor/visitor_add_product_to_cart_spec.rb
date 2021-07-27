require 'rails_helper'

describe 'add products to cart' do
  context 'adding' do
    it 'successfully all products' do
      create(:product, name: 'Nome do Produto 1', brand: 'Marca do Produto 1',
                       description: 'Descrição sobre este produto', price: 30,
                       height: '2', width: '1', length: '3',
                       weight: '4', sku: 'woeife3483ru')

      visit root_path

      expect(page).to have_content('Nome do Produto 1')
      expect(page).to have_content('R$ 30,00')
      expect(page).to have_content('Marca do Produto 1')
    end
    it 'successfully show product' do
      create(:product, name: 'Nome do Produto 1', brand: 'Marca do Produto 1',
                       description: 'Descrição sobre este produto', height: '2', width: '1',
                       length: '3', weight: '4', sku: 'woeife3483ru')
      stock_json = File.read(Rails.root.join('spec/fixtures/product_stock.json'))
      allow(Faraday).to receive(:get)
        .with('http://whoknows2', params: { sku: 'woeife3483ru' })
        .and_return(instance_double(Faraday::Response, status: 200,
                                                       body: stock_json))

      visit root_path
      click_on 'Nome do Produto 1'

      expect(page).to have_content('Nome do Produto 1')
      expect(page).to have_content('Descrição sobre este produto')
      expect(page).to have_content('R$ 20')
      expect(page).to have_content('Marca do Produto 1')
      expect(page).to have_content('2.0 m')
      expect(page).to have_content('1.0 m')
      expect(page).to have_content('3.0 m')
      expect(page).to have_content('4.0 kg')
    end
    it 'successfully see shippings options' do
      product = create(:product, name: 'Nome do Produto 1', brand: 'Marca do Produto 1',
                                 description: 'Descrição sobre este produto',
                                 price: 30, height: '2', width: '1',
                                 length: '3', weight: '4', sku: 'woeife3483ru')
      attributes = product.as_json(only: %i[sku weight length width])
      shippings_json = File.read(Rails.root.join('spec/fixtures/shippings.json'))
      stock_json = File.read(Rails.root.join('spec/fixtures/product_stock.json'))
      allow(Faraday).to receive(:get)
        .with('http://whoknows2', params: { sku: 'woeife3483ru' })
        .and_return(instance_double(Faraday::Response, status: 200,
                                                       body: stock_json))
      allow(Faraday).to receive(:get)
        .with('http://whoknows', params: { **attributes, cep: '13015301' })
        .and_return(instance_double(Faraday::Response, status: 200,
                                                       body: shippings_json))
      visit root_path
      click_on 'Nome do Produto 1'
      fill_in 'CEP', with: '13015301'
      click_on 'Calcular por CEP'

      expect(page).to have_content('Frete 1')
      expect(page).to have_content('R$ 15,00')
      expect(page).to have_content('10 dias úteis')
      expect(page).to have_content('Frete 2')
      expect(page).to have_content('R$ 12,00')
      expect(page).to have_content('15 dias úteis')
    end
    it 'no product in stock' do
      product = create(:product, name: 'Nome do Produto 1', brand: 'Marca do Produto 1',
                                 description: 'Descrição sobre este produto',
                                 price: 30, height: '2', width: '1',
                                 length: '3', weight: '4', sku: 'woeife3483ru')
      shippings_json = File.read(Rails.root.join('spec/fixtures/shippings.json'))
      no_stock_json = File.read(Rails.root.join('spec/fixtures/no_product_stock.json'))
      attributes = product.as_json(only: %i[sku weight length width])
      allow(Faraday).to receive(:get)
        .with('http://whoknows2', params: { sku: 'woeife3483ru' })
        .and_return(instance_double(Faraday::Response, status: 200,
                                                       body: no_stock_json))
      allow(Faraday).to receive(:get)
        .with('http://whoknows', params: { **attributes, cep: '13015301' })
        .and_return(instance_double(Faraday::Response, status: 200,
                                                       body: shippings_json))

      visit root_path
      click_on 'Nome do Produto 1'

      expect(current_path).to eq(product_path(product))
      expect(page).to_not have_button('Calcular por CEP')
    end
    it 'successfully add product to cart' do
      user = create(:user)
      create(:address, user: user)
      product = create(:product, name: 'Nome do Produto 1', brand: 'Marca do Produto 1',
                                 description: 'Descrição sobre este produto',
                                 price: 30, height: '2', width: '1',
                                 length: '3', weight: '4', sku: 'woeife3483ru')
      attributes = product.as_json(only: %i[sku weight length width])
      shippings_json = File.read(Rails.root.join('spec/fixtures/shippings.json'))
      stock_json = File.read(Rails.root.join('spec/fixtures/product_stock.json'))
      one_shipping_json = File.read(Rails.root.join('spec/fixtures/one_shipping.json'))
      allow(Faraday).to receive(:get)
        .with('http://whoknows2', params: { sku: 'woeife3483ru' })
        .and_return(instance_double(Faraday::Response, status: 200,
                                                       body: stock_json))
      allow(Faraday).to receive(:get)
        .with('http://whoknows', params: { **attributes, cep: '13015301' })
        .and_return(instance_double(Faraday::Response, status: 200,
                                                       body: shippings_json))
      allow(Faraday).to receive(:get)
        .with('http://whoknows3', params: { shipping_id: '3' })
        .and_return(instance_double(Faraday::Response, status: 200,
                                                       body: one_shipping_json))

      login_as user, scope: :user
      visit root_path
      click_on 'Nome do Produto 1'
      fill_in 'CEP', with: '13015301'
      click_on 'Calcular por CEP'
      click_on 'Adicionar ao carrinho'
      click_on 'Nome do Produto 1'

      expect(current_path).to eq(users_cart_path(Cart.last.id))
      expect(page).to have_content('Nome do Produto 1')
      expect(page).to have_content('R$ 30,00')
      expect(page).to have_content('Marca do Produto 1')
      expect(page).to have_content('Unidade(s): 1')
    end
    it 'after create cart see cart index' do
      user = create(:user)
      create(:address, user: user)
      product = create(:product, name: 'Nome do Produto 1', brand: 'Marca do Produto 1',
                                 description: 'Descrição sobre este produto',
                                 price: 30, height: '2', width: '1',
                                 length: '3', weight: '4', sku: 'woeife3483ru')
      attributes = product.as_json(only: %i[sku weight length width])
      shippings_json = File.read(Rails.root.join('spec/fixtures/shippings.json'))
      stock_json = File.read(Rails.root.join('spec/fixtures/product_stock.json'))
      one_shipping_json = File.read(Rails.root.join('spec/fixtures/one_shipping.json'))
      allow(Faraday).to receive(:get)
        .with('http://whoknows2', params: { sku: 'woeife3483ru' })
        .and_return(instance_double(Faraday::Response, status: 200,
                                                       body: stock_json))
      allow(Faraday).to receive(:get)
        .with('http://whoknows', params: { **attributes, cep: '13015301' })
        .and_return(instance_double(Faraday::Response, status: 200,
                                                       body: shippings_json))
      allow(Faraday).to receive(:get)
        .with('http://whoknows3', params: { shipping_id: '3' })
        .and_return(instance_double(Faraday::Response, status: 200,
                                                       body: one_shipping_json))
      login_as user, scope: :user
      visit root_path
      click_on 'Nome do Produto 1'
      fill_in 'CEP', with: '13015301'
      click_on 'Calcular por CEP'
      click_on 'Adicionar ao carrinho'

      expect(page).to have_content('Produto adicionado ao carrrinho com sucesso!')
    end
    it 'must be logged in to add_cart' do
      product = create(:product, name: 'Nome do Produto 1', brand: 'Marca do Produto 1',
                                 description: 'Descrição sobre este produto',
                                 price: 30, height: '2', width: '1',
                                 length: '3', weight: '4', sku: 'woeife3483ru')
      attributes = product.as_json(only: %i[sku weight length width])
      shippings_json = File.read(Rails.root.join('spec/fixtures/shippings.json'))
      stock_json = File.read(Rails.root.join('spec/fixtures/product_stock.json'))
      one_shipping_json = File.read(Rails.root.join('spec/fixtures/one_shipping.json'))
      allow(Faraday).to receive(:get)
        .with('http://whoknows2', params: { sku: 'woeife3483ru' })
        .and_return(instance_double(Faraday::Response, status: 200,
                                                       body: stock_json))
      allow(Faraday).to receive(:get)
        .with('http://whoknows', params: { **attributes, cep: '13015301' })
        .and_return(instance_double(Faraday::Response, status: 200,
                                                       body: shippings_json))
      allow(Faraday).to receive(:get)
        .with('http://whoknows3', params: { shipping_id: '3' })
        .and_return(instance_double(Faraday::Response, status: 200,
                                                       body: one_shipping_json))

      visit root_path
      click_on 'Nome do Produto 1'
      fill_in 'CEP', with: '13015301'
      click_on 'Calcular por CEP'

      expect(page).to_not have_button('Adicionar ao Carrinho')
    end
  end
end
