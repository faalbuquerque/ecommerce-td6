require 'rails_helper'

describe Category do
  context 'validation' do
    it { should validate_presence_of(:name).with_message('não pode ficar em branco') }

    it 'name must to be uniq' do
      create(:category, name: 'Informática')
      category = Category.new(name: 'Informática')

      category.valid?

      expect(category.errors[:name]).to include('já está em uso')
    end
  end
end
