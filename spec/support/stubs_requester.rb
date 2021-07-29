def find_shippings(attributes, shippings_json, cep)
  allow(Faraday).to receive(:get)
    .with('http://shipping', params: { **attributes, cep: cep })
    .and_return(instance_double(Faraday::Response, status: 200,
                                                   body: shippings_json))
end

def find_stock_product(sku, stock_json)
  allow(Faraday).to receive(:get)
    .with('http://stock', params: { sku: sku })
    .and_return(instance_double(Faraday::Response, status: 200,
                                                   body: stock_json))
end

