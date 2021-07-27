require 'rails_helper'

describe Cart do
  it { should belong_to(:product) }
  it { should validate_presence_of(:product_id) }
  it { should validate_presence_of(:shipping_id) }
end
