--[[
    Mahjong PlayerDrawState

    1. This is the state where the player draws one tile.
    2. This state is after 
        a) DealerPickingState -> Player is dealer 
        b) Player PONG or GANG --> Draws Replacement Tile
        c) AI (left of player) discards a tile -> Draws Tile
]]

PlayerDrawState = Class{__includes = BaseState}

function PlayerDrawState:init(tileColor, jokerstring, drawWall, hands, flowerWalls, discardedTiles)
    
    self.selected_x = 1 
    self.selected_y = 3

    self.selectionBox = selectionBox(1, 2, {13, 1}, 3)
    self.menu = playerGUI({0, 0, 0, 0, 0})

end

function PlayerDrawState:enter(params)

    self.tileColor = params.tileColor
    self.jokerstring = params.jokerstring
    self.drawWall = params.drawWall

    self.playerHand, self.rightHand, self.oppoHand, self.leftHand = params.hands[1], params.hands[2], params.hands[3], params.hands[4]
    table.sort(self.playerHand, function (t1, t2) return t1.id < t2.id end) -- to create fn for later hand

    self.playerFlowerWall, self.rightFlowerWall, self.oppoFlowerWall, self.leftFlowerWall = params.flowerWalls[1], params.flowerWalls[2], params.flowerWalls[3], params.flowerWalls[4]
    self.flowerDeckCounter = #self.playerFlowerWall
    self.flowerinHand = 0

    self.playerDiscardedTiles, self.rightDiscardedTiles, self.oppoDiscardedTiles, self.leftDiscardedTiles = params.discardedTiles[1], params.discardedTiles[2], params.discardedTiles[3], params.discardedTiles[4]
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

    -- draws tile until playerHand = 13
    if #self.playerHand - self.flowerinHand < 13 then
        gSounds['tile-draw']:play()
        local tileToBeDrawn = self.drawWall[1]
        tileToBeDrawn.area = 1
        table.insert(self.playerHand, tileToBeDrawn)
        table.remove(self.drawWall, 1)
    end

end

function PlayerDrawState:update(dt)

    self.selectionBox:update(dt)

    -- draw tile
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        local x_pos, y_pos = self.selectionBox:returnCords()
        if x_pos == 1 and y_pos == 3 then

            -- offically transfer playerHand's bonus tiles into self.playerFlowerWall
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

            gStateMachine:change('playerDiscard',
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

function PlayerDrawState:render()

    -- background
    love.graphics.draw(gTextures['background'], 0, 0, 0, 
        VIRTUAL_WIDTH / gTextures['background']:getWidth(),
        VIRTUAL_HEIGHT / gTextures['background']:getHeight())

    for p = 1, #self.playerHand do
        self.playerHand[p]:render()
    end

    self.menu:render()
    self.selectionBox:render()

    -- Debugging Code
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.printf(#self.rightHand, VIRTUAL_WIDTH * 0.8, VIRTUAL_HEIGHT * 0.5, VIRTUAL_WIDTH * 0.9, "left")
    love.graphics.setColor(1, 1, 1, 1)

    Timer.after(1, function()
        self.menu["DrawUI"]["available"] = 1
        self.selected_y = 3
    end)

    if self.playerFlowerWall ~= nil then
        for q = 1, #self.playerFlowerWall do
            self.playerFlowerWall[q]:render()
        end
    end
    
end