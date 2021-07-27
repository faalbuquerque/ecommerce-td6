require 'rails_helper'

describe Product do
  it { should validate_presence_of(:sku) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:brand) }
  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:price) }
  it { should validate_presence_of(:length) }
  it { should validate_presence_of(:width) }
  it { should validate_presence_of(:height) }
  it { should validate_presence_of(:weight) }
  it { should validate_uniqueness_of(:sku) }
  it { should have_many(:product_categories) }
  it { should have_many(:categories) }
end
