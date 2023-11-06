require_relative '../player/ship.rb'
require_relative '../shared/block.rb'

class GameScreen
  attr_accessor :is_super_shot, :avaliable_super_shot, :count_super_shot

  def initialize(rows, cols, board_player, selecteds_ship)
    @rows = rows
    @cols = cols
    @board_player = board_player
    @board_enemy = Array.new(@rows) { Array.new(@cols, 0) }
    @selecteds_ship = selecteds_ship
    @blocks_player = []
    @blocks_enemy = []
    @block_size = App.class_variable_get(:@@canvas).block_size
    @width_canvas = App.class_variable_get(:@@canvas).width
    @destroyed_enemy_ships = 0
    @count_shots = []
    @is_super_shot = false
    @avaliable_super_shot = true
    @count_super_shot = 2
    @text_super_shot = Text.new('SUPER TIROS DISPONIVEIS: %d' %[count_super_shot], size: 26, y: 120)
    @text_super_shot.x = (App.class_variable_get(:@@canvas).width - @text_super_shot.width) / 2
    @text_is_super_shot = Text.new(' ', size: 10, x: 0, y: 0)

    render
  end

  def active_super_shot
    @text_is_super_shot.remove
    @text_is_super_shot = Text.new('SUPER TIRO ATIVADO', size: 26, y: 180)
    @text_is_super_shot.x = (App.class_variable_get(:@@canvas).width - @text_is_super_shot.width) / 2
  end

  def render
    title_text = Text.new('Comecou o jogo', size: 64, y: 40)
    title_text.x = (App.class_variable_get(:@@canvas).width - title_text.width) / 2

    x_displacement = 25
    y_displacement = 250

    (0...@rows).each do |row|
      (0...@cols).each do |col|
        @blocks_player << Block.new(x_displacement + col * (@block_size + 2), y_displacement + row * (@block_size + 2), 0)
      end
    end

    render_enemy_board
    @blocks_player.each(&:draw)
    @selecteds_ship.each { |ship| Image.new(ship.ship.path, width: ship.ship.width, height: ship.ship.height, z: ship.ship.z + 10, x: ship.ship.x, y: ship.ship.y, rotate: ship.ship.rotate)}
  end

  def place_ship(board, size)
    loop do
      row = rand(board.length)
      col = rand(board[0].length)

      orientation = [:horizontal, :vertical].sample

      valid_placement = true

      if orientation == :horizontal
        valid_placement = (col + size <= board[0].length)
      else
        valid_placement = (row + size <= board.length)
      end

      if valid_placement
        if orientation == :horizontal
          valid_placement = board[row][col...(col + size)].all? { |cell| cell == 0 }
        else
          valid_placement = (row...(row + size)).all? { |r| board[r][col] == 0 }
        end
      end

      if valid_placement
        if orientation == :horizontal
          (col...(col + size)).each { |c| board[row][c] = 1 }
        else
          (row...(row + size)).each { |r| board[r][col] = 1 }
        end
        break
      end
    end
  end

  def player_win?
    @destroyed_enemy_ships == 30
  end

  def update
    @blocks_enemy.each(&:remove)
    @blocks_enemy.each(&:draw)
  end

  def default_shot(row, col)
    if @count_shots.length < 3
      if @blocks_enemy[row * @cols + col].state == 0
        @blocks_enemy[row * @cols + col].state = -1

        @count_shots << [row, col]
        update
      end
    end

    if @count_shots.length == 3
      handle_single_shot(@count_shots[0][0], @count_shots[0][1])
      handle_single_shot(@count_shots[1][0], @count_shots[1][1])
      handle_single_shot(@count_shots[2][0], @count_shots[2][1])

      @count_shots = []
    end
  end

  def handle_single_shot(row, col)
    @avaliable_super_shot = true
    if @board_enemy[row][col] == 0
      @board_enemy[row][col] = 2
      @blocks_enemy[row * @cols + col].state = 2
      puts "Tiro na água."
      update
    elsif @board_enemy[row][col] == 1
      @board_enemy[row][col] = 2
      @blocks_enemy[row * @cols + col].state = 1
      @destroyed_enemy_ships += 1
      puts "Você atingiu o navio inimigo!"
      update
    end
  end

  def super_shot(row, col)
    # Verifique se a posição selecionada é válida
    if valid_position?(row, col)
      if @board_enemy[row][col] != 0
        puts "Esse bloco já foi atingido."
        return
      end
      # Lance um "tiro" no bloco central
      handle_single_shot(row, col)
  
      # Verifique os blocos vizinhos
      [-1, 0, 1].each do |r_offset|
        [-1, 0, 1].each do |c_offset|
          r = row + r_offset
          c = col + c_offset
          # Verifique se a posição é válida
          if valid_position?(r, c)
            handle_single_shot(r, c)
          end
        end
      end

      @text_super_shot.remove
      @text_super_shot = Text.new('SUPER TIROS DISPONIVEIS: %d' %[count_super_shot], size: 26, y: 120)
      @text_super_shot.x = (App.class_variable_get(:@@canvas).width - @text_super_shot.width) / 2
      @text_is_super_shot.remove
    end
  end
  
  def valid_position?(row, col)
    row >= 0 && row < @rows && col >= 0 && col < @cols
  end

  def render_enemy_board
    text_player = Text.new('Player', size: 26, y: 200)
    text_player.x = (25 + @cols * (@block_size + 2) - text_player.width) / 2

    text_enemy = Text.new('Enemy', size: 26, y: 200)
    text_enemy.x = @width_canvas - text_enemy.width + 25 - (@cols * (@block_size + 2)) / 2

    x_displacement = @width_canvas - (25 + @cols * (@block_size + 2))
    y_displacement = 250

    (0...@rows).each do |row|
      (0...@cols).each do |col|
        @blocks_enemy << Block.new(x_displacement + col * (@block_size + 2), y_displacement + row * (@block_size + 2), @board_enemy[row][col])
      end
    end

    @blocks_enemy.each(&:draw)

    place_ship(@board_enemy, 5)
    place_ship(@board_enemy, 4)
    place_ship(@board_enemy, 4)
    place_ship(@board_enemy, 3)
    place_ship(@board_enemy, 3)
    place_ship(@board_enemy, 3)
    place_ship(@board_enemy, 2)
    place_ship(@board_enemy, 2)
    place_ship(@board_enemy, 2)
    place_ship(@board_enemy, 2)
  end
end