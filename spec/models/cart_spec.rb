require 'rails_helper'

describe Cart do
  it { should belong_to(:product) }
  it { should validate_presence_of(:quantity) }
  it { should validate_presence_of(:product_id) }
end
