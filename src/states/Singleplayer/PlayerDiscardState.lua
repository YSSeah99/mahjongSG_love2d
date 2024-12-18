--[[
    Mahjong PlayerDiscardState

    1. This is the state where the player decides which of the 14 tiles to discard, provided that his tiles do not meet the winning conditions.
    2. This state is after 
        a) leftAI (left of Player) discards a tile and end its turn -> rightAIDrawState
        b) leftAI (left of Player) discards a tile -> RightAI CHI
        c) AIs (any player) discards a tile -> Player PONG or GANG 
]]

PlayerDiscardState = Class{__includes = BaseState}

function PlayerDiscardState:init(tileColor, jokerstring, drawWall, hands, flowerWalls, discardedTiles)
    
    self.selected_x = 14
    self.selected_y = 2

    self.menu = playerGUI({0, 0, 0, 0, 0})

end

function PlayerDiscardState:enter(params)

    self.tileColor = params.tileColor
    self.jokerstring = params.jokerstring
    self.drawWall = params.drawWall

    self.playerHand, self.rightHand, self.oppoHand, self.leftHand = params.hands[1], params.hands[2], params.hands[3], params.hands[4]

    self.playerFlowerWall, self.rightFlowerWall, self.oppoFlowerWall, self.leftFlowerWall = params.flowerWalls[1], params.flowerWalls[2], params.flowerWalls[3], params.flowerWalls[4]
    self.flowerDeckCounter = #self.playerFlowerWall
    self.flowerinHand = 0

    self.playerDiscardedTiles, self.rightDiscardedTiles, self.oppoDiscardedTiles, self.leftDiscardedTiles = params.discardedTiles[1], params.discardedTiles[1], params.discardedTiles[1], params.discardedTiles[1]

    -- assign pos in playerHand after it is sorted
    for pos = 1, #self.playerHand do
        self.playerHand[pos].position = pos
    end

    -- assign any bonus tile to playerFlowerHand
    for pos = 1, #self.playerHand do
        if self.playerHand[pos].id >= 35 and self.playerHand[pos].id <= 46 then
            self.playerHand[pos].area = 2
            self.playerHand[pos].position = self.flowerDeckCounter + 1
            self.flowerinHand = self.flowerinHand + 1
        end
    end

    -- draws tile until playerHand = 14
    while (#self.playerHand - self.flowerinHand < 14) do
        gSounds['tile-draw']:play()
        local tileToBeDrawn = self.drawWall[1]
        table.remove(self.drawWall, 1)
        if tileToBeDrawn.id >= 35 and tileToBeDrawn.id <= 46 then
            tileToBeDrawn.area = 2
            tileToBeDrawn.position = self.flowerDeckCounter + 1
            table.insert(self.playerFlowerWall, tileToBeDrawn)
        else
            tileToBeDrawn.area = 1
            tileToBeDrawn.position = 14
            table.insert(self.playerHand, tileToBeDrawn)
        end
    end
    
end

function PlayerDiscardState:update(dt)

    if self.selected_y == 2 then
        rightmost_x_counter = 15
    elseif self.selected_y == 1 or self.selected_y == 3 then
        rightmost_x_counter = 2
    end

    -- left and right to select the tile
    if love.keyboard.wasPressed('left') or love.keyboard.wasPressed('a') then
        --gSounds['']:play()
        self.selected_x = math.max(0, self.selected_x - 1)
        if self.selected_x == 0 then self.selected_x = (rightmost_x_counter - 1) end
        
    end
    
    if love.keyboard.wasPressed('right') or love.keyboard.wasPressed('d') then
        --gSounds['']:play()
        self.selected_x = math.min(rightmost_x_counter, self.selected_x + 1)
        if self.selected_x == rightmost_x_counter then self.selected_x = 1 end
        
    end

    if love.keyboard.wasPressed('up') or love.keyboard.wasPressed('w') then
        --gSounds['']:play()
        self.selected_y = math.max(0, self.selected_y - 1)
        if self.selected_y == 0 then self.selected_y = 3 end

        if self.selected_y == 2 then
            if self.selected_x == 2 then
                self.selected_x = 4
            elseif self.selected_x == 3 then
                self.selected_x = 8
            elseif self.selected_x == 4 then
                self.selected_x = 11
            elseif self.selected_x == 5 then
                self.selected_x = 13
            end
        elseif self.selected_y == 1 or self.selected_y == 3 then
            self.selected_x = 1
        end
        
    end

    if love.keyboard.wasPressed('down') or love.keyboard.wasPressed('s') then
        --gSounds['']:play()
        self.selected_y = math.min(4, self.selected_y + 1)
        if self.selected_y == 4 then self.selected_y = 1 end

        if self.selected_y == 2 then
            self.selected_x = 13
        elseif self.selected_y == 1 or self.selected_y == 3 then
            self.selected_x = 1
        end
        
    end
    
    -- draw tile
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gSounds['tile-discard']:play()
        if self.selected_y == 2 then
            local tiletobeDiscarded = self.playerHand[self.selected_x]
            tiletobeDiscarded.area = 3
            tiletobeDiscarded.position = #self.playerDiscardedTiles + 1
            table.insert(self.playerDiscardedTiles, tiletobeDiscarded)
            
            -- re-adjust playerHand
            table.remove(self.playerHand, self.selected_x)

            -- remove any playerHand's bonus tiles into self.playerFlowerWall
            local tilesToDelete = {}
            for pos = 1, #self.playerHand do
                if self.playerHand[pos].area == 2 then
                    table.insert(self.playerFlowerWall, self.playerHand[pos])
                    table.insert(tilesToDelete, pos)
                end
            end
            if tilesToDelete ~= nil then
                for pos = 1, #tilesToDelete do
                    table.remove(self.playerHand, tilesToDelete[#tilesToDelete - pos + 1])
                end
            end

            -- arrange tiles nicely via their idd
            table.sort(self.playerHand, function (t1, t2) return t1.id < t2.id end)
            for pos = 1, #self.playerHand do
                self.playerHand[pos].position = pos
            end

            gStateMachine:change('rightAIDraw',
            {
                tileColor = self.tileColor,
                jokerstring = self.jokerstring,
                drawWall = self.drawWall,
                hands = {self.playerHand, self.rightHand, self.oppoHand, self.leftHand},
                flowerWalls = {self.playerFlowerWall, self.rightFlowerWall, self.oppoFlowerWall, self.leftFlowerWall},
                discardedTiles = {self.playerDiscardedTiles, self.rightDiscardedTiles, self.oppoDiscardedTiles, self.leftDiscardedTiles}
            })
        end
    end 

end

function PlayerDiscardState:render()

    -- need to check for winning condition!!!

    -- background
    love.graphics.draw(gTextures['background'], 0, 0, 0, 
        VIRTUAL_WIDTH / gTextures['background']:getWidth(),
        VIRTUAL_HEIGHT / gTextures['background']:getHeight())

    for p = 1, #self.playerHand do
        self.playerHand[p]:render()
    end

    self.menu:render()

    if #self.playerFlowerWall ~= 0 then
        for q = 1, #self.playerFlowerWall do
            self.playerFlowerWall[q].area = 2
            self.playerFlowerWall[q]:render()
        end
    end

    -- Debugging Code
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.printf(#self.rightHand, VIRTUAL_WIDTH * 0.8, VIRTUAL_HEIGHT * 0.5, VIRTUAL_WIDTH * 0.9, "left")
    love.graphics.setColor(1, 1, 1, 1)

    -- if tile is selected, it will be highlighted with a red border
    if self.selected_y == 1 then 
        love.graphics.setLineWidth(2)
        love.graphics.setColor(189/255, 44/255, 32/255, 1)
        love.graphics.rectangle('line', 
        VIRTUAL_WIDTH * 0.8, VIRTUAL_HEIGHT * 0.1, 
        TOP_PANEL_WIDTH, TOP_PANEL_HEIGHT)
    
    elseif self.selected_y == 2 then
        love.graphics.setLineWidth(2)
        love.graphics.setColor(189/255, 44/255, 32/255, 1)
        love.graphics.rectangle('line', 
        HandPosn[self.selected_x],
        VIRTUAL_HEIGHT * 0.74, 
        TILE_WIDTH, TILE_HEIGHT)
        
    elseif self.selected_y == 3 then
        love.graphics.setLineWidth(2)
        love.graphics.setColor(189/255, 44/255, 32/255, 1)
        love.graphics.rectangle('line', 
        bottomPanelPosn[self.selected_x],
        VIRTUAL_HEIGHT * 0.9, 
        BOTTOM_PANEL_WIDTH, BOTTOM_PANEL_HEIGHT)
    end

    -- reset the color
    love.graphics.setColor(1, 1, 1, 1)

end