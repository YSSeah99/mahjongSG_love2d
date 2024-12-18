--[[
    Mahjong rightAIDiscardState

    1. This is the state where the rightAI decides which of the 14 tiles to discard, provided that his tiles do not meet the winning conditions.
    2. This state is after 
        a) Player (left of rightAI) discards a tile and end its turn -> rightAIDrawState
        b) Player (left of rightAI) discards a tile -> RightAI CHI
        c) AI/Player (any player) discards a tile -> RightAI PONG or GANG 
]]

rightAIDiscardState = Class{__includes = BaseState}

function rightAIDiscardState:init(tileColor, jokerstring, drawWall, hands, flowerWalls, discardedTiles)
    
    self.menu = playerGUI({0, 0, 0, 0, 0})

end

function rightAIDiscardState:enter(params)

    gSounds['tile-discard']:play()

    self.tileColor = params.tileColor
    self.jokerstring = params.jokerstring
    self.drawWall = params.drawWall

    self.playerHand, self.rightHand, self.oppoHand, self.leftHand = params.hands[1], params.hands[2], params.hands[3], params.hands[4]

    self.playerFlowerWall, self.rightFlowerWall, self.oppoFlowerWall, self.leftFlowerWall = params.flowerWalls[1], params.flowerWalls[2], params.flowerWalls[3], params.flowerWalls[4]
    self.flowerDeckCounter = #self.rightFlowerWall
    self.flowerinHand = 0

    self.playerDiscardedTiles, self.rightDiscardedTiles, self.oppoDiscardedTiles, self.leftDiscardedTiles = params.discardedTiles[1], params.discardedTiles[1], params.discardedTiles[1], params.discardedTiles[1]

    -- assign pos in rightHand after it is sorted
    for pos = 1, #self.rightHand do
        self.rightHand[pos].position = pos
    end

    -- assign any bonus tile to rightFlowerHand
    for pos = 1, #self.rightHand do
        if self.rightHand[pos].id >= 35 and self.rightHand[pos].id <= 46 then
            self.rightHand[pos].area = 5
            self.rightHand[pos].position = self.flowerDeckCounter + 1
            self.flowerinHand = self.flowerinHand + 1
        end
    end

    -- draws tile until playerHand = 14
    while (#self.rightHand - self.flowerinHand < 14) do
        gSounds['tile-draw']:play()
        local tileToBeDrawn = self.drawWall[1]
        table.remove(self.drawWall, 1)
        if tileToBeDrawn.id >= 35 and tileToBeDrawn.id <= 46 then
            tileToBeDrawn.area = 5
            tileToBeDrawn.position = self.flowerDeckCounter + 1
            table.insert(self.rightFlowerWall, tileToBeDrawn)
        else
            tileToBeDrawn.area = 4
            tileToBeDrawn.position = 14
            table.insert(self.rightHand, tileToBeDrawn)
        end
    end

    -- Debugging Code
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.printf(#self.rightHand, VIRTUAL_WIDTH * 0.8, VIRTUAL_HEIGHT * 0.5, VIRTUAL_WIDTH * 0.9, "left")
    love.graphics.setColor(1, 1, 1, 1)

    Timer.after(1, function()
        if #self.rightHand == 14 then
            local supposedDiscarded = #self.rightDiscardedTiles + 1
            self.randomPosn = math.random(1, 14)
            local tiletobeDiscarded = self.rightHand[self.randomPosn]
            tiletobeDiscarded['area'] = 6
            tiletobeDiscarded.position = #self.rightDiscardedTiles + 1

            table.insert(self.rightDiscardedTiles, tiletobeDiscarded)
            
            -- readjust rightHand
            table.remove(self.rightHand, self.randomPosn)
            table.sort(self.rightHand, function (t1, t2) return t1.id < t2.id end)
            for pos = 1, #self.rightHand do
                self.rightHand[pos].position = pos
            end

            if #self.rightDiscardedTiles == supposedDiscarded then
                gSounds['tile-discard']:play()
                gStateMachine:change('playerDraw',
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
    end)

end

function rightAIDiscardState:update(dt)

    print(dump(self.rightDiscardedTiles))

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
    end 

end

function rightAIDiscardState:render()

    -- need to check for winning condition!!!

    -- background
    love.graphics.draw(gTextures['background'], 0, 0, 0, 
        VIRTUAL_WIDTH / gTextures['background']:getWidth(),
        VIRTUAL_HEIGHT / gTextures['background']:getHeight())

    for p = 1, #self.playerHand do
        self.playerHand[p]:render()
    end
    
    if #self.playerFlowerWall ~= 0 then
        for q = 1, #self.playerFlowerWall do
            self.playerFlowerWall[q]:render()
        end
    end

    -- Temp Code
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.printf(#self.rightHand, VIRTUAL_WIDTH * 0.8, VIRTUAL_HEIGHT * 0.5, VIRTUAL_WIDTH * 0.9, "left")
    love.graphics.setColor(1, 1, 1, 1)

    self.menu:render()

    -- reset the color
    love.graphics.setColor(1, 1, 1, 1)

end