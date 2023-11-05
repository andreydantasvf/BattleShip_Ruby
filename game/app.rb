require_relative '../config/initializers'

class App
  @@canvas = Shared::Canvas.new

  def initialize
    @title = 'Batalha Naval'
    @width = @@canvas.width
    @height = @@canvas.height
    @resizable = false
    @current_screen = BoardSelectedScreen.new
    @rows = 0
    @cols = 0
  end

  def self.call
    new.call
  end

  def call
    run
  end

  private

  def run
    $engine.set(title: @title, background: @background, resizable: @resizable, width: @width, height: @height)

    update_moviments

    $engine.show
  end

  def update_moviments
    $engine.on :key_up do |event|
      case @current_screen
      when BoardSelectedScreen
        if event.key == 'w' && @current_screen.selected_option > 0
          @current_screen.selected_option -= 1
          @current_screen.render
        elsif event.key == 's' && @current_screen.selected_option < @current_screen.options.length - 1
          @current_screen.selected_option += 1
          @current_screen.render
        elsif event.key == 'return' || event.key == 'enter'
          case @current_screen.options[@current_screen.selected_option]
          when "Tabuleiro 8x12"
            Window.clear
            @rows = 8
            @cols = 12
            @current_screen = ShipsSelectedScreen.new(8, 12)
          when "Tabuleiro 10x15"
            Window.clear
            @rows = 10
            @cols = 15
            @current_screen = ShipsSelectedScreen.new(10, 15)
          end
        end
      when ShipsSelectedScreen
        if event.key == 'w'
          @current_screen.ship.move_up
        elsif event.key == 'a'
          @current_screen.ship.move_left
        elsif event.key == 'd'
          @current_screen.ship.move_right
        elsif event.key == 's'
          @current_screen.ship.move_down
        elsif event.key == 'left ctrl'
          @current_screen.ship.move_rotate
        elsif event.key == 'return' || event.key == 'enter'
            @current_screen.select_ship
            if @current_screen.number_ships == 0
              Window.clear
              board = @current_screen.board
              selecteds_ship = @current_screen.selecteds_ship
              @current_screen = GameScreen.new(@rows, @cols, board, selecteds_ship)
            end
        end
      end
    end

    $engine.on :mouse_down do |event|
      case @current_screen
      when GameScreen
        if event.button == :left
          if (event.x > @@canvas.width - (25 + @cols * (@@canvas.block_size + 2)) && event.x < @@canvas.width - 25 && event.y > 250 && event.y < (250 + @rows * (@@canvas.block_size + 2)))
            row = ((event.y - 250) / (@@canvas.block_size + 2)).to_i
            col = ((event.x - (@@canvas.width - (25 + @cols * (@@canvas.block_size + 2)))) / (@@canvas.block_size + 2)).to_i
            @current_screen.handle_click(row, col)
            if @current_screen.player_win?
              Window.clear
              @current_screen = BoardSelectedScreen.new
            end
          end
        end
      end
    end
  end

end

App.call