# frozen_string_literal: true

# Game Class includes the full game including all methods and the board grid itself
class Game
  attr_accessor :turn
  attr_reader :board

  def initialize
    @board = create_grid
    @turn = 1
  end

  def create_grid
    Array.new(6) { Array.new(7) { nil } }
  end

  def game_loop
    # intro message
    puts 'Hello, and welcome to the game of Connect Four!'
    while check_result == 2
      change_turn
      pretty_print_board
      player_turn
    end
    pretty_print_board
    puts end_message(check_result)
  end

  def player_turn
    puts "Player #{@turn + 1}: Please select a row to drop your disc in [1 - 7]"
    valid_input = false
    until valid_input
      begin
        player_input = Integer(gets.chomp)
      rescue ArgumentError
        puts 'Not a number.'
      else
        move_result = play_move(player_input - 1)
        valid_input = true unless move_result == 'Invalid selection' || player_input > 7
      ensure
        puts 'Invalid input, try again!' unless valid_input == true
      end
    end
  end

  def end_message(game_state)
    case game_state
    when 0
      'Congratulations Player 1, you have won!'
    when 1
      'Congratulations Player 2, you have won!'
    else
      'The game is drawn!'
    end
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
    if @turn.zero?
      'X'
    else
      'O'
    end
  end

  def play_move(col)
    return 'Invalid selection' unless @board[0][col].nil?

    disc_colour = set_disc_colour
    @board.each_with_index do |row, index|
      unless row[col].nil?
        return @board[index - 1][col] = disc_colour
      end
    end
    @board[5][col] = disc_colour
  end

  def check_result
    # returns 0 if Player 1 has four in a row, and returns 1 if Player 2 has four in a row
    return @turn if check_verticals || check_horizontals || check_diagonals1 || check_diagonals2
    # returns 2 if the board is not full but neither player has four in a row
    return 2 unless board_full?

    # returns 3 if the board is full
    3
  end

  def check_verticals
    result = false
    7.times do |index|
      column_arr = []
      @board.each do |row|
        column_arr.push(row[index])
      end
      result = true if four_in_a_row?(column_arr)
    end
    result
  end

  def check_horizontals
    result = false
    @board.each do |row|
      result = true if four_in_a_row?(row)
    end
    result
  end

  def check_diagonals1 # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
    result = false
    arr = [[@board[0][3], @board[1][2], @board[2][1], @board[3][0]],
           [@board[0][4], @board[1][3], @board[2][2], @board[3][1], @board[4][0]],
           [@board[0][5], @board[1][4], @board[2][3], @board[3][2], @board[4][1], @board[5][0]],
           [@board[5][1], @board[4][2], @board[3][3], @board[2][4], @board[1][5], @board[0][6]],
           [@board[5][2], @board[4][3], @board[3][4], @board[2][5], @board[1][6]],
           [@board[5][3], @board[4][4], @board[3][5], @board[2][6]]]
    arr.each do |diagonal|
      result = true if four_in_a_row?(diagonal)
    end
    result
  end

  def check_diagonals2 # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
    result = false
    arr = [[@board[2][0], @board[3][1], @board[4][2], @board[5][3]],
           [@board[1][0], @board[2][1], @board[3][2], @board[4][3], @board[5][4]],
           [@board[0][0], @board[1][1], @board[2][2], @board[3][3], @board[4][4], @board[5][5]],
           [@board[0][1], @board[1][2], @board[2][3], @board[3][4], @board[4][5], @board[5][6]],
           [@board[0][2], @board[1][3], @board[2][4], @board[3][5], @board[4][6]],
           [@board[0][3], @board[1][4], @board[2][5], @board[3][6]]]
    arr.each do |diagonal|
      result = true if four_in_a_row?(diagonal)
    end
    result
  end

  def four_in_a_row?(arr) # rubocop:disable Metrics/MethodLength
    disc_colour = set_disc_colour
    max_streak = 0
    current_streak = 0
    arr.each do |item|
      if item == disc_colour
        current_streak += 1
      else
        max_streak = current_streak if current_streak > max_streak
        current_streak = 0
      end
    end
    max_streak = current_streak if current_streak > max_streak
    max_streak > 3
  end

  def board_full?
    flat_board = @board.flatten
    flat_board.each do |square|
      return false if square.nil?
    end
    true
  end

  def pretty_print_board # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
    formatted_board = []
    @board.each do |row|
      formatted_board.push(replace_value(row))
    end

    puts "#{formatted_board[0][0]} #{formatted_board[0][1]} #{formatted_board[0][2]} #{formatted_board[0][3]} #{formatted_board[0][4]} #{formatted_board[0][5]} #{formatted_board[0][6]}" # rubocop:disable Layout/LineLength
    puts "#{formatted_board[1][0]} #{formatted_board[1][1]} #{formatted_board[1][2]} #{formatted_board[1][3]} #{formatted_board[1][4]} #{formatted_board[1][5]} #{formatted_board[1][6]}" # rubocop:disable Layout/LineLength
    puts "#{formatted_board[2][0]} #{formatted_board[2][1]} #{formatted_board[2][2]} #{formatted_board[2][3]} #{formatted_board[2][4]} #{formatted_board[2][5]} #{formatted_board[2][6]}" # rubocop:disable Layout/LineLength
    puts "#{formatted_board[3][0]} #{formatted_board[3][1]} #{formatted_board[3][2]} #{formatted_board[3][3]} #{formatted_board[3][4]} #{formatted_board[3][5]} #{formatted_board[3][6]}" # rubocop:disable Layout/LineLength
    puts "#{formatted_board[4][0]} #{formatted_board[4][1]} #{formatted_board[4][2]} #{formatted_board[4][3]} #{formatted_board[4][4]} #{formatted_board[4][5]} #{formatted_board[4][6]}" # rubocop:disable Layout/LineLength
    puts "#{formatted_board[5][0]} #{formatted_board[5][1]} #{formatted_board[5][2]} #{formatted_board[5][3]} #{formatted_board[5][4]} #{formatted_board[5][5]} #{formatted_board[5][6]}" # rubocop:disable Layout/LineLength
    puts '-------------'
    puts '1 2 3 4 5 6 7'
  end

  def replace_value(arr)
    arr.collect do |value|
      case value
      when 'X'
        '☒'
      when 'O'
        '☐'
      else
        '♢'
      end
    end
  end
end

# initial_grid = [[nil, nil, nil, nil, nil, nil, nil],
#                 [nil, nil, nil, nil, nil, nil, nil],
#                 [nil, nil, nil, nil, nil, nil, nil],
#                 [nil, nil, nil, nil, nil, nil, nil],
#                 [nil, nil, nil, nil, nil, nil, nil],
#                 [nil, nil, nil, nil, nil, nil, nil]]

# test_grid = [[nil, nil, nil, nil, nil, nil, nil],
#              [nil, nil, nil, nil, nil, nil, nil],
#              [nil, nil, nil, nil, nil, nil, nil],
#              [nil, nil, 'O', nil, 'O', nil, nil],
#              [nil, 'O', 'X', 'O', 'X', nil, nil],
#              ['X', 'O', 'X', 'O', 'X', 'O', nil]]

# full_grid = [['O', 'X', 'X', 'X', 'O', 'X', 'X'],
#              ['X', 'O', 'O', 'O', 'X', 'O', 'O'],
#              ['O', 'X', 'O', 'O', 'X', 'X', 'X'],
#              ['O', 'X', 'O', 'X', 'O', 'O', 'O'],
#              ['X', 'O', 'X', 'O', 'X', 'X', 'X'],
#              ['X', 'O', 'X', 'O', 'X', 'O', 'O']]

# o_vertical_win_grid = [[nil, nil, nil, nil, nil, nil, nil],
#                        [nil, nil, nil, nil, nil, nil, nil],
#                        [nil, 'O', nil, nil, nil, nil, nil],
#                        [nil, 'O', 'O', nil, 'O', nil, nil],
#                        [nil, 'O', 'X', 'O', 'X', nil, nil],
#                        ['X', 'O', 'X', 'O', 'X', 'O', nil]]

# o_horizontal_win_grid = [[nil, nil, nil, nil, nil, nil, nil],
#                          [nil, nil, nil, nil, nil, nil, nil],
#                          [nil, nil, nil, nil, nil, nil, nil],
#                          [nil, 'O', 'O', 'O', 'O', nil, nil],
#                          [nil, 'O', 'X', 'O', 'X', nil, nil],
#                          ['X', 'O', 'X', 'O', 'X', 'O', nil]]

# o_diagonal_win_grid1 = [[nil, nil, nil, nil, nil, nil, nil],
#                         [nil, nil, nil, nil, nil, nil, nil],
#                         [nil, 'O', nil, 'O', nil, nil, nil],
#                         [nil, 'X', 'O', 'X', 'O', nil, nil],
#                         [nil, 'O', 'X', 'O', 'X', nil, nil],
#                         ['O', 'O', 'X', 'O', 'X', 'O', nil]]

# o_diagonal_win_grid2 = [[nil, nil, nil, nil, nil, nil, nil],
#                         [nil, nil, nil, nil, nil, nil, nil],
#                         [nil, 'O', nil, 'O', nil, nil, nil],
# #                         [nil, 'X', 'O', 'X', 'O', nil, nil],
# #                         [nil, 'X', 'X', 'O', 'X', 'O', nil],
# #                         [nil, 'O', 'X', 'O', 'X', 'O', 'O']]

# x_vertical_win_grid = [[nil, nil, nil, nil, nil, nil, nil],
#                        [nil, nil, nil, nil, nil, nil, nil],
#                        [nil, 'X', nil, nil, nil, nil, nil],
#                        [nil, 'X', 'O', nil, 'O', nil, nil],
#                        [nil, 'X', 'X', 'O', 'X', nil, nil],
#                        ['O', 'X', 'X', 'O', 'X', 'O', nil]]

# # x_horizontal_win_grid = [[nil, nil, nil, nil, nil, nil, nil],
# #                          [nil, nil, nil, nil, nil, nil, nil],
# #                          [nil, nil, nil, nil, nil, nil, nil],
# #                          [nil, 'X', 'X', 'X', 'X', nil, nil],
# #                          [nil, 'O', 'X', 'O', 'X', nil, nil],
# #                          ['X', 'O', 'X', 'O', 'X', 'O', nil]]

# # x_diagonal_win_grid1 = [[nil, nil, nil, nil, nil, nil, nil],
# #                         [nil, nil, nil, nil, nil, nil, nil],
# #                         [nil, 'O', nil, 'X', nil, nil, nil],
# #                         [nil, 'X', 'X', 'X', 'O', nil, nil],
# #                         [nil, 'X', 'X', 'O', 'X', nil, nil],
# #                         ['X', 'O', 'X', 'O', 'X', 'O', nil]]

# x_diagonal_win_grid2 = [[nil, nil, nil, nil, nil, nil, nil],
#                         [nil, nil, nil, nil, nil, nil, nil],
#                         [nil, 'O', nil, 'X', nil, nil, nil],
#                         [nil, 'X', 'O', 'X', 'X', nil, nil],
#                         [nil, 'X', 'X', 'O', 'X', 'X', nil],
#                         [nil, 'O', 'X', 'O', 'X', 'O', 'X']]

test_game = Game.new
# # test_game.instance_variable_set(:@board, Marshal.load(Marshal.dump(x_diagonal_win_grid2)))
test_game.game_loop
