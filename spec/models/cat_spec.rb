require 'rails_helper'

RSpec.describe Cat, type: :model do
  describe 'validations' do
    it 'cannot create cat without age' do
      cat = Cat.create({
        name: 'is valid',
        age: '',
        enjoys: 'is valid'
      })
      expect(cat.errors[:age]).to_not be_empty
    end
    it 'cannot create cat without name' do
      cat = Cat.create({
        name: '',
        age: 5,
        enjoys: 'is valid'
      })
      expect(cat.errors[:name]).to_not be_empty
    end
    it 'cannot create cat without enjoys' do
      cat = Cat.create({
        name: 'valid',
        age: 5,
        enjoys: ''
      })
      expect(cat.errors[:enjoys]).to_not be_empty
    end
  end
end
