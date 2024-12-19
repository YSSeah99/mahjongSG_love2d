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
    
    self.menu = playerGUI({0, 0, 0, 0, 0})
    self.selectionBox = selectionBox(14, 2, {14, 1}, 2)

end

function PlayerDiscardState:enter(params)

    self.tileColor = params.tileColor
    self.jokerstring = params.jokerstring
    self.drawWall = params.drawWall

    self.playerDeck, self.rightAIDeck, self.oppoAIDeck, self.leftAIDeck = params.decks[1], params.decks[2], params.decks[3], params.decks[4]
    self.playerDiscardedTiles, self.rightDiscardedTiles, self.oppoDiscardedTiles, self.leftDiscardedTiles = params.discardedTiles[1], params.discardedTiles[2], params.discardedTiles[3], params.discardedTiles[4]

    -- draws tile until playerHand = 14
    self.playerDeck:drawTile(self.drawWall)

end

function PlayerDiscardState:update(dt)

    print(dump(self.playerDeck.hands[14]))

    self.selectionBox:update(dt)

    -- draw tile
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        
        local x_pos, y_pos = self.selectionBox:returnCords()

        if y_pos == 2 then
            gSounds['tile-discard']:play()
            local tiletobeDiscarded = self.playerHand[x_pos]
            tiletobeDiscarded.area = 3
            tiletobeDiscarded.position = #self.playerDiscardedTiles + 1
            table.insert(self.playerDiscardedTiles, tiletobeDiscarded)
            
            -- re-adjust playerHand
            table.remove(self.playerHand, x_pos)

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

    self.playerDeck:render()
    AIHandGUI(self.rightAIDeck.hands, self.oppoAIDeck.hands, self.leftAIDeck.hands):render()

    self.menu:render()
    self.selectionBox:render()

end