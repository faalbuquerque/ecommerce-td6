class Stock
  attr_accessor :warehouse_code, :quantity

  def initialize(warehouse_code: nil, quantity: nil)
    @warehouse_code = warehouse_code
    @quantity = quantity
  end

  def self.to_product(params)
    resp = Faraday.get("#{Rails.configuration.external_apis[:stock_api]}/api/v1/ecommerce/warehouses/#{params[:sku]}")
    return [{ quantity: 0 }] unless resp.status == 200

    result = JSON.parse(resp.body, symbolize_names: true)[:warehouses]
    builiding_stock(result)
  rescue Faraday::ConnectionFailed
    [{ quantity: 0 }]
  end

  def self.builiding_stock(result)
    result.each do |stock|
      new(**stock)
    end
  end

  def self.find_address(code)
    resp = Faraday.get("#{Rails.configuration.external_apis[:stock_api]}/api/v1/ecommerce/warehouse/#{code}")
    return nil unless resp.status == 200

    result = JSON.parse(resp.body, symbolize_names: true)
    getting_components(result)
    "#{@street}, #{@number}, #{@district}, #{@city}/#{@state}"
  rescue Faraday::ConnectionFailed
    nil
  end

  def self.reservation(cart, service_order)
    keys_stock = { sku: cart.product.sku, shipping_company: cart.shipping_name,
                   warehouse: cart.warehouse_code, request_number: service_order }
    resp = Faraday.post("#{Rails.configuration.external_apis[:stock_api]}/api/v1/reserve",
                        { reserve: { **keys_stock } })
    return nil unless resp.status == 201

    JSON.parse(resp.body, symbolize_names: true)
  rescue Faraday::ConnectionFailed
    nil
  end

  def self.getting_components(result)
    @street = result[:warehouse][:full_address][:address]
    @number = result[:warehouse][:full_address][:number]
    @district = result[:warehouse][:full_address][:district]
    @city = result[:warehouse][:full_address][:city]
    @state = result[:warehouse][:full_address][:state]
  end
end
