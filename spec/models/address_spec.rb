require 'rails_helper'

describe Address do
  context 'Associations' do
    it { should belong_to(:user) }
  end

  context 'Validations' do
    it { should validate_presence_of(:state) }
    it { should validate_presence_of(:city) }
    it { should validate_presence_of(:cep) }
    it { should validate_presence_of(:neighborhood) }
    it { should validate_presence_of(:street) }
    it { should validate_presence_of(:number) }
  end
RSpec.describe Address, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
end
