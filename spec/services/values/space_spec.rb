require 'rails_helper'

describe Space, type: :model do
  let(:space) {Space.new('A1')}
  let(:ship) {Ship.new(2)}

  it 'exists' do
    expect(space).to be_a(Space)
  end
  it 'will respond with Miss if attacked' do
    expect(space.attack!).to eq('Miss')
  end
  it 'will fill a space with contents and check if occupied' do
    expect(space.occupied?).to eq(false)

    space.occupy!(ship)

    expect(space.occupied?).to eq(true)
  end
  it 'will check if attacked' do
    allow(space).to receive(:contents).and_return(ship)
    expect(space.not_attacked?).to eq(true)

    space.attack!

    expect(space.not_attacked?).to eq(false)
  end
end
