--[[
    Mahjong
]]

Tile = Class{}

function Tile:init(def)

    self.id = def.id -- for sprite rendering
    
    -- 0 = drawTile, 
    -- 1 = playerHand (posn 1 - 14), 2 = flowerHand (posn 1 - 25), 3 = playerDiscardWall
    -- 4 = rightHand (posn 1 - 14), 5 = rightflowerHand (posn 1 - 25), 6 = rightDiscardWall
    -- 7 = oppoHand (posn 1 - 14), 8 = oppoflowerHand (posn 1 - 25), 9 = oppoDiscardWall
    -- 10 = leftHand (posn 1 - 14), 11 = leftflowerHand (posn 1 - 25), 12 = leftDiscardWall
    self.area = def.area 
    self.position = def.position or nil
    
    self.tile_colour = def.tile_colour

    self.class = def.class

    self.suit = def.suit or nil
    self.number = def.number or nil

    self.type = def.type or nil

    self.windNo = def.windNo or nil

    self.animal = def.animal or nil
    self.animalPair = def.animalPair or nil

end

function Tile:update(dt)

end

function Tile:render()

    -- render playerHand
    if self.area == 1 then

        -- draw tiles
        love.graphics.draw(gTextures['tiles_colour'], 
        gFrames['tiles_colour'][self.tile_colour[1]],
        HandPosn[self.position],
        VIRTUAL_HEIGHT * 0.72, 
        0, 
        0.18, 0.18) -- scaling for hand

        -- draw pattern
        love.graphics.draw(gTextures['tiles'], 
        gFrames['tiles'][self.id],
        HandPosn[self.position],
        VIRTUAL_HEIGHT * 0.745, 
        0, 
        0.175, 0.175) 

    -- render playerFlowerWall
    elseif self.area == 2 then

        love.graphics.draw(gTextures['tiles_colour'], 
        gFrames['tiles_colour'][self.tile_colour[1]],
        VIRTUAL_WIDTH * 0.9 - ((26 - self.position) * (TILE_WIDTH * 0.6)),
        VIRTUAL_HEIGHT * 0.7, 
        math.rad(180), 
        0.09, 0.09) -- scaling for hand

        love.graphics.draw(gTextures['tiles'], 
        gFrames['tiles'][self.id],
        VIRTUAL_WIDTH * 0.906 - ((27 - self.position) * (TILE_WIDTH * 0.6)),
        VIRTUAL_HEIGHT * 0.632, 
        0, 
        0.085, 0.085)  -- scaling for hand

    end

    -- tiles stack of 13
    

end