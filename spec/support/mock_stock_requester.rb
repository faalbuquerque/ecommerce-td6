def find_stock_product(sku:, status:)
  stock_json = File.read(Rails.root.join('spec/fixtures/product_stock.json'))

  allow(Faraday).to receive(:get)
    .with("#{Rails.configuration.external_apis[:stock_api]}/api/v1/ecommerce/warehouses/#{sku}")
    .and_return(instance_double(Faraday::Response, status: status, body: stock_json))
end

def failure_stock_connection(sku:)
  allow(Faraday).to receive(:get)
    .with("#{Rails.configuration.external_apis[:stock_api]}/api/v1/ecommerce/warehouses/#{sku}")
    .and_raise(Faraday::ConnectionFailed, nil)
end

def no_stock_product(sku:, status:)
  no_stock_json = File.read(Rails.root.join('spec/fixtures/no_product_stock.json'))

  allow(Faraday).to receive(:get)
    .with("#{Rails.configuration.external_apis[:stock_api]}/api/v1/ecommerce/warehouses/#{sku}")
    .and_return(instance_double(Faraday::Response, status: status, body: no_stock_json))
end

def stock_address_mock(code:, status:)
  stock_address = File.read(Rails.root.join('spec/fixtures/stock_address.json'))
  allow(Faraday).to receive(:get)
    .with("#{Rails.configuration.external_apis[:stock_api]}/api/v1/ecommerce/warehouse/#{code}")
    .and_return(instance_double(Faraday::Response, status: status, body: stock_address))
end

def failure_stock_address(code:)
  allow(Faraday).to receive(:get)
    .with("#{Rails.configuration.external_apis[:stock_api]}/api/v1/ecommerce/warehouse/#{code}")
    .and_raise(Faraday::ConnectionFailed, nil)
end

def notifying_stock(cart:, service_order:, status:)
  stock_reservation = File.read(Rails.root.join('spec/fixtures/stock_reservation.json'))
  keys_stock = { sku: cart.product.sku, shipping_co_id: cart.shipping_id,
                 warehouse_code: cart.warehouse_code, service_order: service_order }
  allow(Faraday).to receive(:post)
    .with("#{Rails.configuration.external_apis[:stock_api]}/api/v1/RESERVADEPRODUTO",
          params: { **keys_stock })
    .and_return(instance_double(Faraday::Response, status: status, body: stock_reservation))
end

def failure_notifying_stock(cart:, service_order:)
  keys_stock = { sku: cart.product.sku, shipping_co_id: cart.shipping_id,
                 warehouse_code: cart.warehouse_code, service_order: service_order }
  allow(Faraday).to receive(:post)
    .with("#{Rails.configuration.external_apis[:stock_api]}/api/v1/RESERVADEPRODUTO",
          params: { **keys_stock })
    .and_raise(Faraday::ConnectionFailed, nil)
end
