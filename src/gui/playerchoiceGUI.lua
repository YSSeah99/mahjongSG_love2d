--[[
    panel

]]

playerchoiceGUI = Class{}

function playerchoiceGUI:init()

end

function playerchoiceGUI:update(dt)

end

function playerchoiceGUI:render(input, discardedtile)

    self.discardedTile = discardedtile

    -- 3 tiles (one option), position 7, 8 and 9 are good
    if input == "Pong?" then

        for i = 1, 3 do
            Tile {
                id = self.discardedTile.id,
                tile_colour = self.discardedTile.tile_colour,
                choice = 2,
                position = i + 6
            }:render()
        end

    end

end