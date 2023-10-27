class Block
  attr_accessor :x, :y, :state
  
  def initialize(x, y, state)
    @x = x
    @y = y
    @state = state
  end
  
  def draw
    if @state == 1
      Square.new(
        x: @x, y: @y,
        size: 40,
        color: 'red'
      )
    elsif @state == 2
      Square.new(
        x: @x, y: @y,
        size: 40,
        color: 'gray'
      )
    else
      Square.new(
        x: @x, y: @y,
        size: 40,
        color: 'blue'
      )
    end
  end
end