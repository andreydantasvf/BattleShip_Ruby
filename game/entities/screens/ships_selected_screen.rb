require_relative '../player/ship.rb'
require_relative '../shared/block.rb'

class ShipsSelectedScreen
  attr_accessor :board, :blocks, :ship, :number_ships, :board, :selecteds_ship

  def initialize(rows, cols)
    @rows = rows
    @cols = cols
    @board = Array.new(rows) { Array.new(cols, 0) }
    @blocks = []
    @width_canvas = App.class_variable_get(:@@canvas).width
    @block_size = App.class_variable_get(:@@canvas).block_size
    @ship = Ship.new('./images/aircraft_carrier.png', 5, 25, 250, @rows, @cols, @board)
    @number_ships = 10
    @selecteds_ship = []

    text_player = Text.new('Player', size: 26, y: 200)
    text_player.x = (25 + @cols * (@block_size + 2) - text_player.width) / 2

    text_enemy = Text.new('Enemy', size: 26, y: 200)
    text_enemy.x = @width_canvas - text_enemy.width + 25 - (@cols * (@block_size + 2)) / 2
    
    render_enemy_board
    render
  end

  def render
    title_text = Text.new('SELECIONE OS SEUS NAVIOS', size: 64, y: 40)
    title_text.x = (@width_canvas - title_text.width) / 2

    sub_title = Text.new('NAVIOS DISPONIVEIS: %d' %[@number_ships], size: 26, y: 120)
    sub_title.x = (@width_canvas - sub_title.width) / 2

    x_displacement = 25
    y_displacement = 250

    (0...@rows).each do |row|
      (0...@cols).each do |col|
        @blocks << Block.new(x_displacement + col * (@block_size + 2), y_displacement + row * (@block_size + 2), @board[row][col])
      end
    end

    @blocks.each(&:draw)

    @selecteds_ship.each { |ship| Image.new(ship.ship.path, width: ship.ship.width, height: ship.ship.height, z: ship.ship.z + 10, x: ship.ship.x, y: ship.ship.y, rotate: ship.ship.rotate)}
  end

  def render_enemy_board
    x_displacement = @width_canvas - (25 + @cols * (@block_size + 2))
    y_displacement = 250

    (0...@rows).each do |row|
      (0...@cols).each do |col|
        @blocks << Block.new(x_displacement + col * (@block_size + 2), y_displacement + row * (@block_size + 2), 0)
      end
    end

    @blocks.each(&:draw)
  end

  def select_ship
    selected, board = @ship.enter
    if selected == true && @number_ships > 0
      @number_ships -= 1
      @selecteds_ship << @ship.dup
      @board = board
      Window.clear

      if @number_ships < 5
        @ship = Ship.new('./images/submarine.png', 2, 25, 250, @rows, @cols, @board)
      elsif @number_ships < 8
        @ship = Ship.new('./images/destroyers.png', 3, 25, 250, @rows, @cols, @board)
      elsif @number_ships < 10
        @ship = Ship.new('./images/tankers.png', 4, 25, 250, @rows, @cols, @board)
      end

      render
    end
  end
end