--[[
    Mahjong
]]

selectionBox = Class{}

function selectionBox:init(x, y, rightmostXcounter)

    self.x = x
    self.y = y
    self.rightmostXHands, self.rightmostXcounterButtons = rightmostXcounter[1], rightmostXcounter[2]
    -- self.downmostYcounter = downmostYcounter (to be coded)

end

function selectionBox:update(dt)

    if self.y == 1 then
        self.rightmostXcounter = 2
    elseif self.y == 2 then
        self.rightmostXcounter = self.rightmostXHands
    elseif self.y == 3 then
        self.rightmostXcounter = self.rightmostXcounterButtons
    end

    -- left and right to select the tile
    if love.keyboard.wasPressed('left') or love.keyboard.wasPressed('a') then
        --gSounds['']:play()
        self.x = math.max(0, self.x - 1)
        if self.x == 0 then self.x = self.rightmostXcounter end
        
    end
    
    if love.keyboard.wasPressed('right') or love.keyboard.wasPressed('d') then
        --gSounds['']:play()
        self.x = math.min((self.rightmostXcounter + 1), self.x + 1)
        if self.x == (self.rightmostXcounter + 1) then self.x = 1 end
        
    end

    if love.keyboard.wasPressed('up') or love.keyboard.wasPressed('w') then
        --gSounds['']:play()
        self.y = math.max(0, self.y - 1)
        if self.y == 0 then self.y = 3 end

        if self.y == 2 then
            if self.x == 2 then
                self.x = 4
            elseif self.x == 3 then
                self.x = 8
            elseif self.x == 4 then
                self.x = 11
            elseif self.x == 5 then
                self.x = 13
            end
        elseif self.y == 1 or self.y == 3 then
            self.x = 1
        end
        
    end

    if love.keyboard.wasPressed('down') or love.keyboard.wasPressed('s') then
        --gSounds['']:play()
        self.y = math.min(4, self.y + 1)
        if self.y == 4 then self.y = 1 end

        if self.y == 2 then
            self.x = 13
        elseif self.y == 1 or self.y == 3 then
            self.x = 1
        end
        
    end

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then

    end

end

function selectionBox:render()

    -- if tile is selected, it will be highlighted with a red border
    if self.y == 1 then 
        love.graphics.setLineWidth(2)
        love.graphics.setColor(189/255, 44/255, 32/255, 1)
        love.graphics.rectangle('line', 
        VIRTUAL_WIDTH * 0.8, VIRTUAL_HEIGHT * 0.1, 
        TOP_PANEL_WIDTH, TOP_PANEL_HEIGHT)
    
    elseif self.y == 2 then
        love.graphics.setLineWidth(2)
        love.graphics.setColor(189/255, 44/255, 32/255, 1)
        love.graphics.rectangle('line', 
        HandPosn[self.x],
        VIRTUAL_HEIGHT * 0.74, 
        TILE_WIDTH, TILE_HEIGHT)
        
    elseif self.y == 3 then
        love.graphics.setLineWidth(2)
        love.graphics.setColor(189/255, 44/255, 32/255, 1)
        love.graphics.rectangle('line', 
        bottomPanelPosn[self.x],
        VIRTUAL_HEIGHT * 0.9, 
        BOTTOM_PANEL_WIDTH, BOTTOM_PANEL_HEIGHT)
    end

    -- reset the color
    love.graphics.setColor(1, 1, 1, 1)


end

function selectionBox:returnCords()

    return self.x, self.y

end