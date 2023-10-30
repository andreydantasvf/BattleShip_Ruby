class Block
  attr_accessor :x, :y, :state
  
  def initialize(x, y, state)
    @x = x
    @y = y
    @state = state
    @block_size = App.class_variable_get(:@@canvas).block_size
  end
  
  def draw
    if @state == 1
      Square.new(
        x: @x, y: @y,
        size: @block_size,
        color: 'red'
      )
    elsif @state == 2
      Square.new(
        x: @x, y: @y,
        size: @block_size,
        color: 'gray'
      )
    else
      Square.new(
        x: @x, y: @y,
        size: @block_size,
        color: 'blue'
      )
    end
  end
end