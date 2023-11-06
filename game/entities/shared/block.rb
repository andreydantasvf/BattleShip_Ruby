class Block
  attr_accessor :x, :y, :state
  
  def initialize(x, y, state)
    @x = x
    @y = y
    @state = state
    @block_size = App.class_variable_get(:@@canvas).block_size
    @square = Square.new(
      x: @x, y: @y,
      size: @block_size,
      color: 'blue'
    )
  end
  
  def draw
    if @state == 1
      @square = Image.new('./images/explosion.png', x: @x, y: @y, width: @block_size, height: @block_size)
    elsif @state == 2
      @square = Image.new('./images/miss.png', x: @x, y: @y, width: @block_size, height: @block_size)
    elsif @state == -1
      @square = Square.new(
        x: @x, y: @y,
        size: @block_size,
        color: 'gray'
      )
    else
      @square = Square.new(
        x: @x, y: @y,
        size: @block_size,
        color: 'blue'
      )
    end
  end

  def remove
    @square.remove
  end
end