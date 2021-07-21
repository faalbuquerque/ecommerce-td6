class Stock
  attr_accessor :sku, :quantity, :name

  def initialize(sku: nil, quantity: nil, name: nil)
    @sku = sku
    @quantity = quantity
    @name = name
  end

  def self.to_product(params)
    response = Faraday.get('http://whoknows2', params: { sku: params[:sku] })
    return [] unless response.status == 200

    result = JSON.parse(response.body, symbolize_names: true)
    new(**result.except(:id, :created_at, :updated_at))
  end
end
