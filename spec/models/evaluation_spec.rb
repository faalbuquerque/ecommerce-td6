require 'rails_helper'

describe Evaluation do
  it { should validate_presence_of(:rate) }
  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:product_id) }
end
