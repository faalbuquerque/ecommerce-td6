class Shipping
  include ActionView::Helpers::NumberHelper
  include ActiveModel::Model
  attr_accessor :cep, :city, :name, :distance, :price, :arrival_time, :shipping_id,
                :state, :district, :street, :number, :complement, :latitude, :longitude, :id

  def display_name
    "#{@name} - Preço: #{number_to_currency(@price)} - Prazo de entrega: #{@arrival_time} dias úteis"
  end

  def self.find(params)
    response = Faraday.get 'http://shippingfind', params: { shipping_id: params[:shipping_id] }
    return new unless response.status == 200

    shipping = JSON.parse(response.body, symbolize_names: true)
    new(**shipping.except(:created_at, :updated_at, :cep, :city))
  rescue Faraday::ConnectionFailed
    new
  end

  def self.to_product(product, zip)
    attributes = product.as_json(only: %i[sku weight length width height])
    response = Faraday.get('http://shipping', params: { cep: zip, **attributes })
    return [] unless response.status == 200

    result = JSON.parse(response.body, symbolize_names: true)
    from_json_array(result)
  rescue Faraday::ConnectionFailed
    []
  end

  def self.from_json_array(array)
    array.map do |shipping|
      new(**shipping.except(:created_at, :updated_at))
    end
  end
end
