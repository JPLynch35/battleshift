require 'rails_helper'

RSpec.describe Shooter, type: :model do
  it 'exists' do
    board = Board.new(4)
    target = 'A1'
    shooter = Shooter.new(board: board, target: target)

    expect(shooter).to be_a(Shooter)
  end
  it 'can fire!' do
    board = Board.new(4)
    target = 'A1'
    shooter = Shooter.new(board: board, target: target)

    expect(shooter.fire!).to eq('Miss')
  end
end
