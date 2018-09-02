require 'rails_helper'

describe Ship, type: :model do
  it 'exists' do
    ship = Ship.new(2)

    expect(ship).to be_a(Ship)
  end

  it 'has attributes' do
    ship = Ship.new(2)

    expect(ship.length). to eq(2)
    expect(ship.damage). to eq(0)
  end
  
  describe 'instance methods' do
    it 'can be attacked and increase in damage by 1' do
      ship = Ship.new(2)
      ship.attack!

      expect(ship.damage).to eq(1)
    end
    it 'can be sunk' do
      ship = Ship.new(2)

      expect(ship.is_sunk?).to be(false)

      ship.attack!
      ship.attack!

      expect(ship.is_sunk?).to be(true)
    end
  end
end
