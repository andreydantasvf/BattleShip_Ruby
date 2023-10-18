class Game
  def initialize(window)
    @window = window
    @visible = false
  end

  def render
    @window.clear
    @square = Square.new(x: 10, y: 20, size: 25, color: 'blue')
  end
end