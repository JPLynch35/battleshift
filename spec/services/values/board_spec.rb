require 'rails_helper'

describe Board do
  it 'exists' do
    board = Board.new(4)

    expect(board).to be_a(Board)
  end

  it 'has attributes' do
    board = Board.new(4)

    expect(board.length). to eq(4)
  end
  
  describe 'instance methods' do
    it 'can get row letters' do
      board = Board.new(4)

      expect(board.get_row_letters).to eq(["A", "B", "C", "D"])
    end
    it 'can get column numbers' do
      board = Board.new(4)

      expect(board.get_column_numbers).to eq(["1", "2", "3", "4"])
    end
    it 'can get space names' do
      board = Board.new(4)

      expect(board.space_names).to eq(["A1", "A2", "A3", "A4", "B1", "B2", "B3", "B4", "C1", "C2", "C3", "C4", "D1", "D2", "D3", "D4"])
    end
    it 'can create spaces' do
      board = Board.new(4)

      expect(board.create_spaces.first).to be_a(Array)
      expect(board.create_spaces.first.second).to be_a(Space)
    end
    it 'can assign spaces to rows' do
      board = Board.new(4)

      expected = [["A1", "A2", "A3", "A4"], ["B1", "B2", "B3", "B4"], ["C1", "C2", "C3", "C4"], ["D1", "D2", "D3", "D4"]]
      expect(board.assign_spaces_to_rows).to eq(expected)
    end
    it 'can create grid' do
      board = Board.new(4)

      expected = [["A1", "A2", "A3", "A4"], ["B1", "B2", "B3", "B4"], ["C1", "C2", "C3", "C4"], ["D1", "D2", "D3", "D4"]]
      expect(board.assign_spaces_to_rows).to eq(expected)
    end
    it 'can located specified space' do
      board = Board.new(4)

      coords = "A4"
      expect(board.locate_space(coords)).to be_a(Space)
      expect(board.locate_space(coords).coordinates).to eq('A4')
    end
  end
end
