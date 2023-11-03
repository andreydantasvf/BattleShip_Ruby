require_relative '../player/ship.rb'
require_relative '../shared/block.rb'

class GameScreen
  def initialize(rows, cols, board_player, selecteds_ship)
    @rows = rows
    @cols = cols
    @board_player = board_player
    @selecteds_ship = selecteds_ship
    @blocks = []
    @block_size = App.class_variable_get(:@@canvas).block_size
    @width_canvas = App.class_variable_get(:@@canvas).width

    render
  end

  def render
    title_text = Text.new('Comecou o jogo', size: 64, y: 40)
    title_text.x = (App.class_variable_get(:@@canvas).width - title_text.width) / 2

    x_displacement = 25
    y_displacement = 250

    (0...@rows).each do |row|
      (0...@cols).each do |col|
        @blocks << Block.new(x_displacement + col * (@block_size + 2), y_displacement + row * (@block_size + 2), 0)
      end
    end

    render_enemy_board
    @blocks.each(&:draw)
    @selecteds_ship.each { |ship| Image.new(ship.ship.path, width: ship.ship.width, height: ship.ship.height, z: ship.ship.z + 10, x: ship.ship.x, y: ship.ship.y, rotate: ship.ship.rotate)}
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
        @blocks << Block.new(x_displacement + col * (@block_size + 2), y_displacement + row * (@block_size + 2), 0)
      end
    end

    @blocks.each(&:draw)
  end
end