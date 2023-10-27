require_relative '../player/ship.rb'

class ShipsSelectedScreen
  attr_accessor :board, :blocks, :ship

  def initialize(rows, cols)
    @rows = rows
    @cols = cols
    @board = Array.new(rows) { Array.new(cols, 0) }
    @blocks = []
    @ship = Ship.new('./images/ShipBattleshipHull.png', 5, ((App.class_variable_get(:@@canvas).width - @cols * (40 + 2)) / 2), 250, @rows, @cols, @board)
    @selecteds_ship = []
    
    render
  end

  def render
    title_text = Text.new('SELECIONE OS SEUS NAVIOS', size: 64, y: 40)
    title_text.x = (App.class_variable_get(:@@canvas).width - title_text.width) / 2

    x_displacement = (App.class_variable_get(:@@canvas).width - @cols * (40 + 2)) / 2
    y_displacement = 250

    (0...@rows).each do |row|
      (0...@cols).each do |col|
        @blocks << Block.new(x_displacement + col * (40 + 2), y_displacement + row * (40 + 2), @board[row][col])
      end
    end

    @blocks.each(&:draw)
    @selecteds_ship.each { |ship| Image.new(ship.ship.path, width: ship.ship.width, height: ship.ship.height, z: @ship.ship.z + 10, x: ship.ship.x, y: ship.ship.y, rotate: ship.ship.rotate)}
  end

  def select_ship
    selected, board = @ship.enter
    if selected == true
      @selecteds_ship << @ship.dup
      @board = board
      Window.clear
      @ship = Ship.new('./images/ShipBattleshipHull.png', 2, ((App.class_variable_get(:@@canvas).width - @cols * (40 + 2)) / 2), 250, @rows, @cols, @board)
      render
    end
  end
end

class Block
  attr_accessor :x, :y, :state
  
  def initialize(x, y, state)
    @x = x
    @y = y
    @state = state
  end
  
  def draw
    Square.new(
      x: @x, y: @y,
      size: 40,
      color: 'blue'
    )
  end
end