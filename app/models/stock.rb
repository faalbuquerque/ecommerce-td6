class Stock
  attr_accessor :sku, :quantity, :name

  def initialize(sku: nil, quantity: nil, name: nil)
    @sku = sku
    @quantity = quantity
    @name = name
  end

  def self.to_product(params)
    response = Faraday.get("#{Rails.configuration.external_apis[:stock_api]}/stock",
                           params: { sku: params[:sku] })
    return new(quantity: 0) unless response.status == 200

    result = JSON.parse(response.body, symbolize_names: true)
    new(**result.except(:id, :created_at, :updated_at))
  rescue Faraday::ConnectionFailed
    new(quantity: 0)
  end
end
