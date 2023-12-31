require_relative '../player/ship.rb'
require_relative '../shared/block.rb'

class GameScreen
  attr_accessor :is_super_shot, :avaliable_super_shot, :count_super_shot, :score

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
    @destroyed_player_ships = 0
    @count_shots = []
    @is_super_shot = false
    @avaliable_super_shot = true
    @count_super_shot = 2
    @text_super_shot = Text.new('SUPER TIROS DISPONIVEIS: %d' %[count_super_shot], size: 26, y: 120)
    @text_super_shot.x = (App.class_variable_get(:@@canvas).width - @text_super_shot.width) / 2
    @text_is_super_shot = Text.new(' ', size: 10, x: 0, y: 0)
    @hits_board = []
    @super_shot_enemy = 0
    @score = 0
    @hit_count = 0
    @miss_count = 0

    render
  end

  def efficiency_bonus
    if @hit_count > 0 && @miss_count == 0
      bonus = @hit_count * 5
      @score += bonus
    end
  end

  def toogle_active_super_shot
    @is_super_shot = !is_super_shot
    @text_is_super_shot.remove
    if @is_super_shot
      @text_is_super_shot = Text.new('SUPER TIRO ATIVADO', size: 26, y: 180)
      @text_is_super_shot.x = (App.class_variable_get(:@@canvas).width - @text_is_super_shot.width) / 2
    end
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

  def enemy_win?
    @destroyed_player_ships == 30
  end

  def update
    @blocks_enemy.each(&:remove)
    @blocks_enemy.each(&:draw)

    @blocks_player.each(&:remove)
    @blocks_player.each(&:draw)
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

      @avaliable_super_shot = true

      enemy_shot

      @count_shots = []
    end
  end

  def enemy_shot
    if @super_shot_enemy < 2
      enemy_super_shot
      @super_shot_enemy += 1
    else
      enemy_fire
      enemy_fire
      enemy_fire
    end
  end

  def handle_single_shot(row, col)
    if @board_enemy[row][col] == 0
      @board_enemy[row][col] = 2
      @blocks_enemy[row * @cols + col].state = 2
      @score -= 5
      @hit_count = 0
      @miss_count += 1
      update
    elsif @board_enemy[row][col] == 1
      @board_enemy[row][col] = 2
      @blocks_enemy[row * @cols + col].state = 1
      @destroyed_enemy_ships += 1
      @score += 10
      @hit_count += 1
      @miss_count = 0
      efficiency_bonus
      update
    end
  end

  def handle_enemy_single_shot(row, col)
    if @board_player[row][col] == 0
      @board_player[row][col] = 2
      @blocks_player[row * @cols + col].state = 2
      update
    elsif @board_player[row][col] == 1
      @board_player[row][col] = 2
      @blocks_player[row * @cols + col].state = -2
      @destroyed_player_ships += 1
      update
    end
  end

  def super_shot(row, col)
    # Verifique se a posição selecionada é válida
    if valid_position?(row, col)
      if @board_enemy[row][col] == 2
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

      @is_super_shot = false
      @count_super_shot -= 1
      @text_super_shot.remove
      @text_super_shot = Text.new('SUPER TIROS DISPONIVEIS: %d' %[count_super_shot], size: 26, y: 120)
      @text_super_shot.x = (App.class_variable_get(:@@canvas).width - @text_super_shot.width) / 2
      @text_is_super_shot.remove
      enemy_shot
    end
  end

  def enemy_super_shot
    # Gere uma posição aleatória para o tiro do inimigo
    row = rand(@board_player.length)
    col = rand(@board_player[row].length)
    
    # Verifique se a posição selecionada é válida
    if valid_position?(row, col)
      # Lance um "tiro" no bloco central
      handle_enemy_single_shot(row, col)
    
      # Verifique os blocos vizinhos
      [-1, 0, 1].each do |r_offset|
        [-1, 0, 1].each do |c_offset|
          r = row + r_offset
          c = col + c_offset
          # Verifique se a posição é válida
          if valid_position?(r, c)
            handle_enemy_single_shot(r, c)
          end
        end
      end
    end
  end

  def enemy_fire
    loop do
      if @hits_board.empty?
        # Escolhe aleatoriamente uma posição no tabuleiro do jogador
        row = rand(@board_player.length)
        col = rand(@board_player[row].length)
      else
        # Se houver acertos anteriores, tente disparar nas proximidades
        target = @hits_board.sample # Escolha um acerto anterior aleatório
  
        # Gere uma lista de posições vizinhas ao alvo
        adjacent_positions = [
          [target[0] - 1, target[1]],
          [target[0] + 1, target[1]],
          [target[0], target[1] - 1],
          [target[0], target[1] + 1]
        ]
  
        # Filtrar posições válidas
        valid_positions = adjacent_positions.select do |row, col|
          row >= 0 && row < @board_player.length && col >= 0 && col < @board_player[row].length && @board_player[row][col] != 2
        end
  
        if valid_positions.empty?
          # Se não houver posições vizinhas válidas, faça um disparo aleatório
          row = rand(@board_player.length)
          col = rand(@board_player[row].length)
        else
          # Escolha uma posição vizinha válida aleatoriamente
          row, col = valid_positions.sample
          # puts 'vizinho row %d col %d' %[row, col]
        end
      end

      # Verifica se a posição ainda não foi atingida (0 representa água)
      if @board_player[row][col] == 0
        @board_player[row][col] = 2 # Marca como "tiro na água"
        @blocks_player[row * @cols + col].state = 2
        @hits_board = [] # Registre o acerto
        update
        return
      elsif @board_player[row][col] == 1
        @board_player[row][col] = 2 # Marca como "navio atingido"
        @blocks_player[row * @cols + col].state = -2
        @destroyed_player_ships += 1
        @hits_board << [row, col] # Registre o acerto
        update
        return
      end
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