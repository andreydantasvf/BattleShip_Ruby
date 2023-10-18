require 'ruby2d'

require_relative './lib/menu/menu'
require_relative './lib/menu/start_menu/start_menu'
require_relative './lib/game'

set width: 800, height: 600

window = Window.new

menu = Menu.new(window)
start_menu = StartMenu.new(window)
game = Game.new(window)

show_start_menu = false
show_game = false

on :key_down do |event|
  if show_start_menu
    start_menu.handle_input(event)
    if start_menu.show_game
      show_game = true
      show_start_menu = false
    end
  else
    menu.handle_input(event)
    if menu.start_selected
      show_start_menu = true
    end
  end
end

update do
  clear
  if show_start_menu
    start_menu.render
  elsif show_game
    game.render
  else
    menu.render
  end
end

show