class Shipping
  include ActionView::Helpers::NumberHelper
  include ActiveModel::Model
  attr_accessor :cep, :name, :distance, :price, :arrival_time, :shipping_id,
                :latitude, :longitude, :id, :warehouse_code

  def display_name
    "#{@name} - Preço: #{number_to_currency(@price)} - Prazo de entrega: #{@arrival_time} dias úteis"
  end

  def self.chosen(shipping)
    return new if shipping.empty?

    result = JSON.parse(shipping, symbolize_names: true)
    new(**result)
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
      attributes = { shipping_id: shipping[:shipping_co][:id],
                     name: shipping[:shipping_co][:name],
                     warehouse_code: shipping[:warehouse][:warehouse_code],
                     price: shipping[:price],
                     arrival_time: shipping[:shipment_days] }
      new(**attributes)
    end
  end
end
