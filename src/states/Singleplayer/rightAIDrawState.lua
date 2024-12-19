--[[
    Mahjong rightAIDrawState

    1. This is the state where the rightplayerAI draws one tile.
    2. This state is after 
        a) DealerPickingState -> RightAI is dealer 
        b) Right Opponent PONG or GANG --> Draws Replacement Tile
        c) Player (left of rightplayerAI) discards a tile -> Draws Tile
]]

rightAIDrawState = Class{__includes = BaseState}

function rightAIDrawState:init(tileColor, jokerstring, drawWall, hands, flowerWalls, discardedTiles)
    
    self.menu = playerGUI({0, 0, 0, 0, 0})

end

function rightAIDrawState:enter(params)

    self.tileColor = params.tileColor
    self.jokerstring = params.jokerstring
    self.drawWall = params.drawWall

    self.playerHand, self.rightHand, self.oppoHand, self.leftHand = params.hands[1], params.hands[2], params.hands[3], params.hands[4]
    table.sort(self.playerHand, function (t1, t2) return t1.id < t2.id end)

    self.playerFlowerWall, self.rightFlowerWall, self.oppoFlowerWall, self.leftFlowerWall = params.flowerWalls[1], params.flowerWalls[2], params.flowerWalls[3], params.flowerWalls[4]
    self.flowerDeckCounter = #self.rightFlowerWall -- for positioning
    self.flowerinHand = 0 -- accounts for number of flowerTiles in rightHand
    
    self.playerDiscardedTiles, self.rightDiscardedTiles, self.oppoDiscardedTiles, self.leftDiscardedTiles = params.discardedTiles[1], params.discardedTiles[2], params.discardedTiles[3], params.discardedTiles[4]

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

    -- draws tile until rightHand = 13
    if #self.rightHand - self.flowerinHand < 13 then
        local tileToBeDrawn = self.drawWall[1]
        tileToBeDrawn.area = 4
        table.insert(self.rightHand, tileToBeDrawn)
        table.remove(self.drawWall, 1)
    end

end

function rightAIDrawState:update(dt)

    -- draw tile
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        --gSounds['']:play()

            -- offically transfer playerHand's bonus tiles into self.playerFlowerWall
    end 

end

function rightAIDrawState:render()

    -- background
    love.graphics.draw(gTextures['background'], 0, 0, 0, 
        VIRTUAL_WIDTH / gTextures['background']:getWidth(),
        VIRTUAL_HEIGHT / gTextures['background']:getHeight())

    playerHandGUI(self.playerHand, self.playerFlowerWall):render()
    AIHandGUI(self.rightHand, self.oppoHand, self.leftHand):render()

    self.menu:render()

    Timer.after(1, function()
    
        -- offically transfer rightHand's bonus tiles into self.rightFlowerWall
        local tilesToDelete = {}
        for pos = 1, #self.rightHand do
            if self.rightHand[pos].area == 5 then
                table.insert(self.rightFlowerWall, self.rightHand[pos])
                table.insert(tilesToDelete, pos)
            end
        end
        if tilesToDelete ~= nil then
            for pos = 1, #tilesToDelete do
                table.remove(self.rightHand, tilesToDelete[#tilesToDelete - pos + 1])
            end
        end

        gStateMachine:change('rightAIDiscard',
        {
            tileColor = self.tileColor,
            jokerstring = self.jokerstring,
            drawWall = self.drawWall,
            hands = {self.playerHand, self.rightHand, self.oppoHand, self.leftHand},
            flowerWalls = {self.playerFlowerWall, self.rightFlowerWall, self.oppoFlowerWall, self.leftFlowerWall},
            discardedTiles = {self.playerDiscardedTiles, self.rightDiscardedTiles, self.oppoDiscardedTiles, self.leftDiscardedTiles}
        })

    end)

    -- reset the color
    love.graphics.setColor(1, 1, 1, 1)

end