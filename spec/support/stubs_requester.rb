def find_shippings(attributes, shippings_json, custumer)
  allow(Faraday).to receive(:get)
    .with("#{Rails.configuration.external_apis[:shipping_api]}/api/v1/shippings",
          params: { product: attributes, custumer: custumer })
    .and_return(instance_double(Faraday::Response, status: 200,
                                                   body: shippings_json))
end

def find_stock_product(sku, stock_json)
  allow(Faraday).to receive(:get)
    .with("#{Rails.configuration.external_apis[:stock_api]}/api/v1/ecommerce/warehouses/#{sku}")
    .and_return(instance_double(Faraday::Response, status: 200,
                                                   body: stock_json))
end
