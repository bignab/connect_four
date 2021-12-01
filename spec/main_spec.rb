# frozen_string_literal: true

# spec/main_spec.rb

require './lib/main'

initial_grid = [[nil, nil, nil, nil, nil, nil, nil],
                [nil, nil, nil, nil, nil, nil, nil],
                [nil, nil, nil, nil, nil, nil, nil],
                [nil, nil, nil, nil, nil, nil, nil],
                [nil, nil, nil, nil, nil, nil, nil],
                [nil, nil, nil, nil, nil, nil, nil]]

test_grid = [[nil, nil, nil, nil, nil, nil, nil],
             [nil, nil, nil, nil, nil, nil, nil],
             [nil, nil, nil, nil, nil, nil, nil],
             [nil, nil, 'O', nil, 'O', nil, nil],
             [nil, 'O', 'X', 'O', 'X', nil, nil],
             ['X', 'O', 'X', 'O', 'X', 'O', nil]]

full_grid = [['O', 'X', 'X', 'X', 'O', 'X', 'X'], # rubocop:disable Style/WordArray
             ['X', 'O', 'O', 'O', 'X', 'O', 'O'], # rubocop:disable Style/WordArray
             ['O', 'X', 'O', 'O', 'X', 'X', 'X'], # rubocop:disable Style/WordArray
             ['O', 'X', 'O', 'X', 'O', 'O', 'O'], # rubocop:disable Style/WordArray
             ['X', 'O', 'X', 'O', 'X', 'X', 'X'], # rubocop:disable Style/WordArray
             ['X', 'O', 'X', 'O', 'X', 'O', 'O']] # rubocop:disable Style/WordArray

o_vertical_win_grid = [[nil, nil, nil, nil, nil, nil, nil],
                       [nil, nil, nil, nil, nil, nil, nil],
                       [nil, 'O', nil, nil, nil, nil, nil],
                       [nil, 'O', 'O', nil, 'O', nil, nil],
                       [nil, 'O', 'X', 'O', 'X', nil, nil],
                       ['X', 'O', 'X', 'O', 'X', 'O', nil]]

o_horizontal_win_grid = [[nil, nil, nil, nil, nil, nil, nil],
                         [nil, nil, nil, nil, nil, nil, nil],
                         [nil, nil, nil, nil, nil, nil, nil],
                         [nil, 'O', 'O', 'O', 'O', nil, nil],
                         [nil, 'O', 'X', 'O', 'X', nil, nil],
                         ['X', 'O', 'X', 'O', 'X', 'O', nil]]

o_diagonal_win_grid1 = [[nil, nil, nil, nil, nil, nil, nil],
                        [nil, nil, nil, nil, nil, nil, nil],
                        [nil, 'O', nil, 'O', nil, nil, nil],
                        [nil, 'X', 'O', 'X', 'O', nil, nil],
                        [nil, 'O', 'X', 'O', 'X', nil, nil],
                        ['O', 'O', 'X', 'O', 'X', 'O', nil]]

o_diagonal_win_grid2 = [[nil, nil, nil, nil, nil, nil, nil],
                        [nil, nil, nil, nil, nil, nil, nil],
                        [nil, 'O', nil, 'O', nil, nil, nil],
                        [nil, 'X', 'O', 'X', 'O', nil, nil],
                        [nil, 'X', 'X', 'O', 'X', 'O', nil],
                        [nil, 'O', 'X', 'O', 'X', 'O', 'O']]

x_vertical_win_grid = [[nil, nil, nil, nil, nil, nil, nil],
                       [nil, nil, nil, nil, nil, nil, nil],
                       [nil, 'X', nil, nil, nil, nil, nil],
                       [nil, 'X', 'O', nil, 'O', nil, nil],
                       [nil, 'X', 'X', 'O', 'X', nil, nil],
                       ['O', 'X', 'X', 'O', 'X', 'O', nil]]

x_horizontal_win_grid = [[nil, nil, nil, nil, nil, nil, nil],
                         [nil, nil, nil, nil, nil, nil, nil],
                         [nil, nil, nil, nil, nil, nil, nil],
                         [nil, 'X', 'X', 'X', 'X', nil, nil],
                         [nil, 'O', 'X', 'O', 'X', nil, nil],
                         ['X', 'O', 'X', 'O', 'X', 'O', nil]]

x_diagonal_win_grid1 = [[nil, nil, nil, nil, nil, nil, nil],
                        [nil, nil, nil, nil, nil, nil, nil],
                        [nil, 'O', nil, 'X', nil, nil, nil],
                        [nil, 'X', 'X', 'X', 'O', nil, nil],
                        [nil, 'X', 'X', 'O', 'X', nil, nil],
                        ['X', 'O', 'X', 'O', 'X', 'O', nil]]

x_diagonal_win_grid2 = [[nil, nil, nil, nil, nil, nil, nil],
                        [nil, nil, nil, nil, nil, nil, nil],
                        [nil, 'O', nil, 'X', nil, nil, nil],
                        [nil, 'X', 'O', 'X', 'X', nil, nil],
                        [nil, 'X', 'X', 'O', 'X', 'X', nil],
                        [nil, 'O', 'X', 'O', 'X', 'O', 'X']]

describe Game do
  subject { Game.new }

  describe '#create_grid' do
    it 'creates a seven-column and six-row grid' do
      expect(subject.create_grid).to eql(initial_grid)
    end
  end

  describe '#play_move' do
    context "while Player 1's turn" do
      it 'place X at the bottom of selected column' do
        subject.change_turn if subject.turn == 1
        subject.instance_variable_set(:@board, Marshal.load(Marshal.dump(test_grid)))
        subject.play_move(2)
        expect(subject.board[2][2]).to eql('X')
      end
    end
    context "while Player 2's turn" do
      it 'place O at the bottom of selected column' do
        subject.change_turn if subject.turn == 0
        subject.instance_variable_set(:@board, Marshal.load(Marshal.dump(test_grid)))
        subject.play_move(2)
        expect(subject.board[2][2]).to eql('O')
      end
    end
    it "returns 'Invalid selection' if the column is full" do
      subject.instance_variable_set(:@board, Marshal.load(Marshal.dump(full_grid)))
      subject.play_move(3)
    end
  end

  describe '#change_turn' do
    it 'if @turn = 0, set @turn to 1' do
      subject.change_turn
      expect(subject.turn).to eql(1)
    end

    it 'if @turn = 1, set @turn to 0' do
      subject.turn = 1
      subject.change_turn
      expect(subject.turn).to eql(0)
    end
  end

  describe '#check_result' do
    context 'when Player 1 has four in a row' do
      it 'aligned vertically' do
        subject.instance_variable_set(:@board, Marshal.load(Marshal.dump(x_vertical_win_grid)))
        expect(subject.check_result).to eql(0) # 0 is the state of P1 victory
      end
      it 'aligned horizontally' do
        subject.instance_variable_set(:@board, Marshal.load(Marshal.dump(x_horizontal_win_grid)))
        expect(subject.check_result).to eql(0) # 0 is the state of P1 victory
      end
      it 'aligned diagonally, bottom-left to top-right' do
        subject.instance_variable_set(:@board, Marshal.load(Marshal.dump(x_diagonal_win_grid1)))
        expect(subject.check_result).to eql(0) # 0 is the state of P1 victory
      end
      it 'aligned diagonally, top-left to bottom-right' do
        subject.instance_variable_set(:@board, Marshal.load(Marshal.dump(x_diagonal_win_grid2)))
        expect(subject.check_result).to eql(0) # 0 is the state of P1 victory
      end
    end
    context 'when Player 2 has four in a row' do
      it 'aligned vertically' do
        subject.turn = 1
        subject.instance_variable_set(:@board, Marshal.load(Marshal.dump(o_vertical_win_grid)))
        expect(subject.check_result).to eql(1) # 1 is the state of P2 victory
      end
      it 'aligned horizontally' do
        subject.turn = 1
        subject.instance_variable_set(:@board, Marshal.load(Marshal.dump(o_horizontal_win_grid)))
        expect(subject.check_result).to eql(1) # 1 is the state of P2 victory
      end
      it 'aligned diagonally, bottom-left to top-right' do
        subject.turn = 1
        subject.instance_variable_set(:@board, Marshal.load(Marshal.dump(o_diagonal_win_grid1)))
        expect(subject.check_result).to eql(1) # 1 is the state of P2 victory
      end
      it 'aligned diagonally, top-left to bottom-right' do
        subject.turn = 1
        subject.instance_variable_set(:@board, Marshal.load(Marshal.dump(o_diagonal_win_grid2)))
        expect(subject.check_result).to eql(1) # 1 is the state of P2 victory
      end
    end
    context 'when neither player has four in a row' do
      it 'and the board is not full' do
        subject.instance_variable_set(:@board, Marshal.load(Marshal.dump(test_grid)))
        expect(subject.check_result).to eql(2) # 2 is the state of an ongoing game
      end
      it 'and the board is full' do
        subject.instance_variable_set(:@board, Marshal.load(Marshal.dump(full_grid)))
        expect(subject.check_result).to eql(3) # 3 is the state of a drawn game
      end
    end
  end
end
