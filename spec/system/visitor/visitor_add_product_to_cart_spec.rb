require 'rails_helper'

describe 'add products to cart' do
  context 'view' do
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
        .with('http://stock', params: { sku: 'woeife3483ru' })
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
      expect(page).to have_css('img[src*="product.jpg"]')
    end
    it 'successfully see shippings options' do
      product = create(:product, name: 'Nome do Produto 1', brand: 'Marca do Produto 1',
                                 description: 'Descrição sobre este produto',
                                 price: 30, height: '2', width: '1',
                                 length: '3', weight: '4', sku: 'woeife3483ru')
      attributes = product.as_json(only: %i[sku weight length width height])
      shippings_json = File.read(Rails.root.join('spec/fixtures/shippings.json'))
      stock_json = File.read(Rails.root.join('spec/fixtures/product_stock.json'))
      allow(Faraday).to receive(:get)
        .with('http://stock', params: { sku: 'woeife3483ru' })
        .and_return(instance_double(Faraday::Response, status: 200,
                                                       body: stock_json))
      allow(Faraday).to receive(:get)
        .with('http://shipping', params: { **attributes, cep: '13015301' })
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
      attributes = product.as_json(only: %i[sku weight length width height])
      allow(Faraday).to receive(:get)
        .with('http://stock', params: { sku: 'woeife3483ru' })
        .and_return(instance_double(Faraday::Response, status: 200,
                                                       body: no_stock_json))
      allow(Faraday).to receive(:get)
        .with('http://shipping', params: { **attributes, cep: '13015301' })
        .and_return(instance_double(Faraday::Response, status: 200,
                                                       body: shippings_json))

      visit root_path
      click_on 'Nome do Produto 1'

      expect(current_path).to eq(product_path(product))
      expect(page).to_not have_button('Calcular por CEP')
    end
  end
  context 'adding' do
    it 'successfully add product to cart' do
      user = create(:user)
      create(:address, user: user)
      product = create(:product, name: 'Nome do Produto 1', brand: 'Marca do Produto 1',
                                 description: 'Descrição sobre este produto',
                                 price: 30, height: '2', width: '1',
                                 length: '3', weight: '4', sku: 'woeife3483ru')
      attributes = product.as_json(only: %i[sku weight length width height])
      shippings_json = File.read(Rails.root.join('spec/fixtures/shippings.json'))
      stock_json = File.read(Rails.root.join('spec/fixtures/product_stock.json'))
      allow(Faraday).to receive(:get)
        .with('http://stock', params: { sku: 'woeife3483ru' })
        .and_return(instance_double(Faraday::Response, status: 200,
                                                       body: stock_json))
      allow(Faraday).to receive(:get)
        .with('http://shipping', params: { **attributes, cep: '13015301' })
        .and_return(instance_double(Faraday::Response, status: 200,
                                                       body: shippings_json))

      login_as user, scope: :user
      visit root_path
      click_on 'Nome do Produto 1'
      fill_in 'CEP', with: '13015301'
      click_on 'Calcular por CEP'
      choose('Frete 1 - Preço: R$ 15,00 - Prazo de entrega: 10 dias úteis')
      click_on 'Adicionar ao carrinho'

      expect(page).to have_content('Nome do Produto 1')
      expect(page).to have_content('R$ 30,00')
      expect(page).to have_content('Marca do Produto 1')
      expect(page).to have_content('Unidade(s): 1')
      expect(page).to have_content('Frete 1')
      expect(page).to have_content('R$ 15,00')
      expect(page).to have_content('10 dias úteis')
    end
    it 'after create cart see cart index' do
      user = create(:user)
      create(:address, user: user)
      product = create(:product, name: 'Nome do Produto 1', brand: 'Marca do Produto 1',
                                 description: 'Descrição sobre este produto',
                                 price: 30, height: '2', width: '1',
                                 length: '3', weight: '4', sku: 'woeife3483ru')
      attributes = product.as_json(only: %i[sku weight length width height])
      shippings_json = File.read(Rails.root.join('spec/fixtures/shippings.json'))
      stock_json = File.read(Rails.root.join('spec/fixtures/product_stock.json'))
      allow(Faraday).to receive(:get)
        .with('http://stock', params: { sku: 'woeife3483ru' })
        .and_return(instance_double(Faraday::Response, status: 200,
                                                       body: stock_json))
      allow(Faraday).to receive(:get)
        .with('http://shipping', params: { **attributes, cep: '13015301' })
        .and_return(instance_double(Faraday::Response, status: 200,
                                                       body: shippings_json))

      login_as user, scope: :user
      visit root_path
      click_on 'Nome do Produto 1'
      fill_in 'CEP', with: '13015301'
      click_on 'Calcular por CEP'
      choose('Frete 1 - Preço: R$ 15,00 - Prazo de entrega: 10 dias úteis')
      click_on 'Adicionar ao carrinho'

      expect(page).to have_content('Produto adicionado ao carrrinho com sucesso!')
    end
    it 'must be logged in to add_cart' do
      product = create(:product, name: 'Nome do Produto 1', brand: 'Marca do Produto 1',
                                 description: 'Descrição sobre este produto',
                                 price: 30, height: '2', width: '1',
                                 length: '3', weight: '4', sku: 'woeife3483ru')
      attributes = product.as_json(only: %i[sku weight length width height])
      shippings_json = File.read(Rails.root.join('spec/fixtures/shippings.json'))
      stock_json = File.read(Rails.root.join('spec/fixtures/product_stock.json'))
      allow(Faraday).to receive(:get)
        .with('http://stock', params: { sku: 'woeife3483ru' })
        .and_return(instance_double(Faraday::Response, status: 200,
                                                       body: stock_json))
      allow(Faraday).to receive(:get)
        .with('http://shipping', params: { **attributes, cep: '13015301' })
        .and_return(instance_double(Faraday::Response, status: 200,
                                                       body: shippings_json))

      visit root_path
      click_on 'Nome do Produto 1'
      fill_in 'CEP', with: '13015301'
      click_on 'Calcular por CEP'
      choose('Frete 1 - Preço: R$ 15,00 - Prazo de entrega: 10 dias úteis')

      expect(page).to_not have_button('Adicionar ao Carrinho')
    end
    xit 'failure to add product to cart' do
      user = create(:user)
      create(:address, user: user)
      product = create(:product, name: 'Nome do Produto 1', brand: 'Marca do Produto 1',
                                 description: 'Descrição sobre este produto',
                                 price: 30, height: '2', width: '1',
                                 length: '3', weight: '4', sku: 'woeife3483ru')
      attributes = product.as_json(only: %i[sku weight length width height])
      shippings_json = File.read(Rails.root.join('spec/fixtures/shippings.json'))
      stock_json = File.read(Rails.root.join('spec/fixtures/product_stock.json'))
      allow(Faraday).to receive(:get)
        .with('http://stock', params: { sku: 'woeife3483ru' })
        .and_return(instance_double(Faraday::Response, status: 200,
                                                       body: stock_json))
      allow(Faraday).to receive(:get)
        .with('http://shipping', params: { **attributes, cep: '13015301' })
        .and_return(instance_double(Faraday::Response, status: 200,
                                                       body: shippings_json))

      login_as user, scope: :user
      visit root_path
      click_on 'Nome do Produto 1'
      fill_in 'CEP', with: '13015301'
      click_on 'Calcular por CEP'

      click_on 'Adicionar ao carrinho'

      expect(page).to have_content('Obrigatório escolher o frete para adicionar ao carrinho')
    end
  end
  context 'stock' do
    it 'to_product status different from 200 stock' do
      product = create(:product, name: 'Nome do Produto 1', sku: 'woeife3483ru')
      allow(Faraday).to receive(:get)
        .with('http://stock', params: { sku: 'woeife3483ru' })
        .and_return(instance_double(Faraday::Response, status: 500, body: ''))

      visit root_path
      click_on 'Nome do Produto 1'

      expect(current_path).to eq(product_path(product))
      expect(page).to_not have_button('Adicionar ao Carrinho')
    end
    it 'Connection failure in stock api' do
      create(:product, name: 'Nome do Produto 1', sku: 'woeife3483ru')
      allow(Faraday).to receive(:get)
        .with('http://stock', params: { sku: 'woeife3483ru' })
        .and_raise(Faraday::ConnectionFailed, nil)

      visit root_path
      click_on 'Nome do Produto 1'

      expect(page).to_not have_button('Adicionar ao Carrinho')
    end
  end
  context 'shipping' do
    it 'to_product not status 200' do
      product = create(:product, name: 'Nome do Produto 1', sku: 'woeife3483ru')
      attributes = product.as_json(only: %i[sku weight length width height])
      stock_json = File.read(Rails.root.join('spec/fixtures/product_stock.json'))

      allow(Faraday).to receive(:get)
        .with('http://stock', params: { sku: 'woeife3483ru' })
        .and_return(instance_double(Faraday::Response, status: 200,
                                                       body: stock_json))
      allow(Faraday).to receive(:get)
        .with('http://shipping', params: { **attributes, cep: '13015301' })
        .and_return(instance_double(Faraday::Response, status: 500, body: ''))

      visit root_path
      click_on 'Nome do Produto 1'
      fill_in 'CEP', with: '13015301'
      click_on 'Calcular por CEP'

      expect(page).to_not have_button('Adicionar ao Carrinho')
      expect(page).to have_content('Não foi possível calcular o frete')
    end
    it 'to_product Connection failure in shipping api' do
      product = create(:product, name: 'Nome do Produto 1', sku: 'woeife3483ru')
      stock_json = File.read(Rails.root.join('spec/fixtures/product_stock.json'))
      attributes = product.as_json(only: %i[sku weight length width height])

      allow(Faraday).to receive(:get)
        .with('http://stock', params: { sku: 'woeife3483ru' })
        .and_return(instance_double(Faraday::Response, status: 200,
                                                       body: stock_json))
      allow(Faraday).to receive(:get)
        .with('http://shipping', params: { **attributes, cep: '13015301' })
        .and_raise(Faraday::ConnectionFailed, nil)

      visit product_path(product)

      fill_in 'CEP', with: '13015301'
      click_on 'Calcular por CEP'

      expect(page).to_not have_button('Adicionar ao Carrinho')
      expect(page).to have_text('Não foi possível calcular o frete')
    end
  end
end
