class Shipping
  include ActionView::Helpers::NumberHelper
  attr_reader :cep, :city, :name, :distance, :price, :arrival_time, :shipping_id,
              :state, :district, :street, :number, :complement
  attr_accessor :latitude, :longitude

  def initialize(name: nil, distance: nil, price: nil, arrival_time: nil,
                 cep: nil, latitude: nil, longitude: nil,
                 shipping_id: nil, state: nil, city: nil, district: nil,
                 street: nil, number: nil, complement: nil, id: nil)
    @cep = cep
    @city = city
    @name = name
    @distance = distance
    @price = price
    @arrival_time = arrival_time
    @latitude = latitude
    @longitude = longitude
    @shipping_id = shipping_id
    @state = state
    @city = city
    @district = district
    @street = street
    @number = number
    @complement = complement
    @shipping_id = shipping_id
    @id = id
  end

  def display_name
    "#{@name} - Preço: #{number_to_currency(@price)} - Prazo de entrega: #{@arrival_time} dias úteis"
  end

  def self.find(params)
    response = Faraday.get 'http://whoknows3', params: { shipping_id: params[:shipping_id] }
    shipping = JSON.parse(response.body, symbolize_names: true)
    new(**shipping.except(:created_at, :updated_at, :cep, :city))
  end

  def self.to_product(params)
    response = Faraday.get('http://whoknows', params: { cep: params[:cep], city: params[:city],
                                                        sku: params[:sku], weight: params[:weight],
                                                        length: params[:length], width: params[:width] })
    return [] unless response.status == 200

    result = JSON.parse(response.body, symbolize_names: true)
    if result.is_a?(Array)
      from_json_array(result)
    else
      new(**result.except(:created_at, :updated_at))
    end
  rescue Faraday::ConnectionFailed
    []
  end

  def self.from_json_array(array)
    array.map do |shipping|
      new(**shipping.except(:created_at, :updated_at))
    end
  end
end
