require 'rails_helper'

describe 'user manages his carts' do
  context 'view carts' do
    it 'view all carts and status' do
      user = create(:user)
      address = create(:address, user: user)
      product_new = create(:product, name: 'Nome do Produto 1', sku: 'woeife3483ru')
      product_old = create(:product, name: 'Nome do Produto 2', sku: 'ipuwfhpu4udd')
      shipping_new = Shipping.new(name: 'Frete 1', shipping_id: '1', service_order: 'SO10000001')
      create(:cart, product: product_new, user: user, shipping_id: shipping_new.shipping_id,
                    address: address, status: 0, service_order: shipping_new.service_order)
      shipping_old = Shipping.new(name: 'Frete 2', shipping_id: '2', service_order: 'SO10000002')
      create(:cart, product: product_old, user: user, shipping_id: shipping_old.shipping_id,
                    address: address, status: 1, service_order: shipping_old.service_order)

      login_as user, scope: :user
      visit root_path
      click_on 'Meus Pedidos'

      expect(page).to have_content('Nome do Produto 1')
      expect(page).to have_content(Time.zone.today.strftime('%d/%m/%Y'))
      expect(page).to have_content('Nome do Produto 2')
    end
    it 'show my orders' do
      user = create(:user)
      address = create(:address, user: user)
      product = create(:product, name: 'Nome do Produto 1', brand: 'Marca do Produto 1',
                                 description: 'Descrição sobre este produto',
                                 price: 30, height: '2', width: '1',
                                 length: '3', weight: '4', sku: 'woeife3483ru')
      shipping = Shipping.new(name: 'Frete 1', shipping_id: '1', service_order: 'SO10000001')
      create(:cart, product: product, user: user, shipping_id: shipping.shipping_id,
                    address: address, status: 1, service_order: shipping.service_order)

      login_as user, scope: :user

      visit root_path
      click_on 'Meus Pedidos'
      click_on 'Nome do Produto 1'

      expect(page).to have_content('Nome do Produto 1')
      expect(page).to have_content('Descrição sobre este produto')
      expect(page).to have_content('R$ 30')
      expect(page).to have_content('Marca do Produto 1')
      expect(page).to have_content('2.0 m')
      expect(page).to have_content('1.0 m')
      expect(page).to have_content('3.0 m')
      expect(page).to have_content('4.0 kg')
      expect(page).to have_content(Time.zone.today.strftime('%d/%m/%Y'))
      expect(page).to have_content('Pedido Entregue')
    end
  end
  context 'change status' do
    it 'order change status successfully' do
      user = create(:user)
      address = create(:address, user: user)
      product = create(:product, name: 'Nome do Produto 1', brand: 'Marca do Produto 1',
                                 description: 'Descrição sobre este produto',
                                 price: 30, height: '2', width: '1',
                                 length: '3', weight: '4', sku: 'woeife3483ru')
      order_status = File.read(Rails.root.join('spec/fixtures/order_status.json'))
      shipping = Shipping.new(name: 'Frete 1', shipping_id: '1', service_order: 'SO10000001')
      create(:cart, product: product, user: user, shipping_id: shipping.shipping_id,
                    address: address, status: 0, service_order: shipping.service_order)
      allow(Faraday).to receive(:get)
        .with("#{Rails.configuration.external_apis[:shipping_api]}/api/v1/service_orders/#{shipping.service_order}")
        .and_return(instance_double(Faraday::Response, status: 200,
                                                       body: order_status))

      login_as user, scope: :user
      visit root_path
      click_on 'Meus Pedidos'
      click_on 'Nome do Produto 1'

      expect(page).to have_content('Nome do Produto 1')
      expect(page).to have_content(Time.zone.today.strftime('%d/%m/%Y'))
      expect(page).to have_content('Pedido Entregue')
    end
    it 'find_status not status 200' do
      user = create(:user)
      address = create(:address, user: user)
      product = create(:product, name: 'Nome do Produto 1')
      shipping = Shipping.new(name: 'Frete 1', shipping_id: '1', service_order: 'SO10000001')
      create(:cart, product: product, user: user, shipping_id: shipping.shipping_id,
                    address: address, status: 0, service_order: shipping.service_order)
      allow(Faraday).to receive(:get)
        .with("#{Rails.configuration.external_apis[:shipping_api]}/api/v1/service_orders/#{shipping.service_order}")
        .and_return(instance_double(Faraday::Response, status: 500,
                                                       body: ''))

      login_as user, scope: :user
      visit root_path
      click_on 'Meus Pedidos'
      click_on 'Nome do Produto 1'

      expect(page).to have_content('Atualização de status temporariamente indisponível')
    end
    it 'find_status Connection failure in shipping api' do
      user = create(:user)
      address = create(:address, user: user)
      product = create(:product, name: 'Nome do Produto 1')
      shipping = Shipping.new(name: 'Frete 1', shipping_id: '1', service_order: 'SO10000001')
      create(:cart, product: product, user: user, shipping_id: shipping.shipping_id,
                    address: address, status: 0, service_order: shipping.service_order)
      allow(Faraday).to receive(:get)
        .with("#{Rails.configuration.external_apis[:shipping_api]}/api/v1/service_orders/#{shipping.service_order}")
        .and_raise(Faraday::ConnectionFailed, nil)

      login_as user, scope: :user
      visit root_path
      click_on 'Meus Pedidos'
      click_on 'Nome do Produto 1'

      expect(page).to have_content('Atualização de status temporariamente indisponível')
    end
  end
end
