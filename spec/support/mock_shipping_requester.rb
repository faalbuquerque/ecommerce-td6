def find_shippings(attributes:, customer:, status:)
  shippings_json = File.read(Rails.root.join('spec/fixtures/shippings.json'))

  allow(Faraday).to receive(:get)
    .with("#{Rails.configuration.external_apis[:shipping_api]}/api/v1/shippings",
          params: { product: attributes, customer: customer })
    .and_return(instance_double(Faraday::Response, status: status, body: shippings_json))
end
# rubocop:disable Metrics/AbcSize

def selling_conclusion(cart:, stock_address:, address:, status:)
  final_shipping = File.read(Rails.root.join('spec/fixtures/final_shipping.json'))
  address_string = address.building_str
  keys_shipping = { sku: cart.product.sku, final_address: address_string, initial_address: stock_address,
                    shipping_co_id: cart.shipping_id, price: cart.shipping_price,
                    shipment_deadline: cart.shipping_time }
  allow(Faraday).to receive(:post)
    .with("#{Rails.configuration.external_apis[:shipping_api]}/api/v1/service_orders",
          params: { service_order: { **keys_shipping } })
    .and_return(instance_double(Faraday::Response, status: status, body: final_shipping))
end
# rubocop:enable Metrics/AbcSize

def failure_selling_conclusion(cart:, stock_address:, address:)
  address_string = address.building_str
  keys_shipping = { sku: cart.product.sku, final_address: address_string, initial_address: stock_address,
                    shipping_co_id: cart.shipping_id, price: cart.shipping_price,
                    shipment_deadline: cart.shipping_time }
  allow(Faraday).to receive(:post)
    .with("#{Rails.configuration.external_apis[:shipping_api]}/api/v1/service_orders",
          params: { service_order: { **keys_shipping } })
    .and_raise(Faraday::ConnectionFailed, nil)
end
