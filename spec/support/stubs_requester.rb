def find_shippings(attributes, shippings_json, cep)
  allow(Faraday).to receive(:get)
    .with('http://whoknows', params: { **attributes, cep: cep })
    .and_return(instance_double(Faraday::Response, status: 200,
                                                   body: shippings_json))
end

def find_shipping(one_shipping_json)
  allow(Faraday).to receive(:get)
    .with('http://whoknows3', params: { shipping_id: '3' })
    .and_return(instance_double(Faraday::Response, status: 200,
                                                   body: one_shipping_json))
end

def find_stock_product(sku, stock_json)
  allow(Faraday).to receive(:get)
    .with('http://whoknows2', params: { sku: sku })
    .and_return(instance_double(Faraday::Response, status: 200,
                                                   body: stock_json))
end
