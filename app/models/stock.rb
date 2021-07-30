class Stock
  attr_accessor :sku, :quantity, :name

  def initialize(sku: nil, quantity: nil, name: nil)
    @sku = sku
    @quantity = quantity
    @name = name
  end

  def self.to_product(params)
    resp = Faraday.get("#{Rails.configuration.external_apis[:stock_api]}/api/v1/ecommerce/warehouses/#{params[:sku]}")
    return new(quantity: 0) unless resp.status == 200

    result = JSON.parse(resp.body, symbolize_names: true)
    new(**result.except(:id, :created_at, :updated_at))
  rescue Faraday::ConnectionFailed
    new(quantity: 0)
  end

  # def self.find_address(code)
  #   resp = Faraday.get("#{Rails.configuration.external_apis[:stock_api]}/api/v1/ecommerce/warehouse/#{code}")
  #   return nil unless resp.status == 200

  #   result = JSON.parse(resp.body, symbolize_names: true)
  #  "#{result[:address]}, #{result[:number]}, #{result[:district]}, #{result[:city]}/#{result[:state]}"
  # rescue Faraday::ConnectionFailed
  #   nil
  # end

  # def self.reservation(keys_stock)
  #   resp = Faraday.post("#{Rails.configuration.external_apis[:stock_api]}/api/v1/RESERVADEPRODUTO"),
  #                       params: { **keys_stock }
  #   return nil unless resp.status == 200
  #
  # rescue Faraday::ConnectionFailed
  #   nil
  # end
end
