# frozen_string_literal: true

# Game Class includes the full game including all methods and the board grid itself
class Game
  attr_accessor :turn
  attr_reader :board

  def initialize
    @board = create_grid
    @turn = 0
  end

  def create_grid
    Array.new(6) { Array.new(7) { nil } }
  end

  def change_turn
    case @turn
    when 0
      @turn = 1
    when 1
      @turn = 0
    end
  end

  def set_disc_colour
    if turn.zero?
      'X'
    else
      'O'
    end
  end

  def play_move(col)
    return 'Invalid selection' unless board[0][col].nil?

    disc_colour = set_disc_colour
    board.each_with_index do |row, index|
      unless row[col].nil?
        board[index - 1][col] = disc_colour
        break
      end
    end
  end

  def check_result
    # check_vertical
    # check_horizontal
    # check_diagonal1
    # check_diagonal2
  end

  def check_vertical(column)
    disc_colour = set_disc_colour
    column_arr = []
    board.each do |row|
      column_arr.push(row[column])
    end
    max_streak = 0
    current_streak = 0
    column_arr.each do |item|
      if item == disc_colour
        current_streak += 1
      else
        max_streak = current_streak
        current_streak = 0
      end
    end
    max_streak > 3
  end

  def check_horizontal(row)
    disc_colour = set_disc_colour

  end
end
