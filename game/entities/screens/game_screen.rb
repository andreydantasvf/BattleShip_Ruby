class GameScreen
  attr_accessor :board, :blocks
  def initialize(rows, cols)
    @rows = rows
    @cols = cols
    @board = Array.new(rows) { Array.new(cols, 0) }
    @blocks = []
    
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