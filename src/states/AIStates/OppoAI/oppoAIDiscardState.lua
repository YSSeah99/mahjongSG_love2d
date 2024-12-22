--[[
    Mahjong oppoAIDiscardState

    1. This is the state where the rightAI decides which of the 14 tiles to discard, provided that his tiles do not meet the winning conditions.
    2. This state is after 
        a) Player (left of rightAI) discards a tile and end its turn -> rightAIDrawState
        b) Player (left of rightAI) discards a tile -> RightAI CHI
        c) AI/Player (any player) discards a tile -> RightAI PONG or GANG 
]]

oppoAIDiscardState = Class{__includes = BaseState}

function oppoAIDiscardState:init(tileColor, jokerstring, drawWall, decks, discardedTiles)
    
    self.menu = playerGUI({0, 0, 0, 0, 0})

end

function oppoAIDiscardState:enter(params)

    gSounds['tile-discard']:play()

    self.tileColor = params.tileColor
    self.jokerstring = params.jokerstring
    self.drawWall = params.drawWall

    self.playerDeck, self.rightAIDeck, self.oppoAIDeck, self.leftAIDeck = params.decks[1], params.decks[2], params.decks[3], params.decks[4]
    self.playerDiscardedTiles, self.rightDiscardedTiles, self.oppoDiscardedTiles, self.leftDiscardedTiles = params.discardedTiles[1], params.discardedTiles[2], params.discardedTiles[3], params.discardedTiles[4]

    self.oppoAIBehaviour = AIBehaviour('oppo', self.oppoAIDeck, self.oppoDiscardedTiles, self.playerDeck)

    self.seconds = 4
    self.dt = 0
    self.countdown = false
    
end

function oppoAIDiscardState:update(dt)

    self.oppoAIDeck:update(dt)
    self.oppoAIBehaviour:update(dt)

    if self.countdown then
        self.dt = self.dt + dt
        if self.dt >= 1 then 
            self.dt = 0 
            self.seconds = self.seconds - 1
        end
    end

    -- draw tile
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
    end 

end

function oppoAIDiscardState:render()

    -- need to check for winning condition!!!

    -- background
    love.graphics.draw(gTextures['background'], 0, 0, 0, 
        VIRTUAL_WIDTH / gTextures['background']:getWidth(),
        VIRTUAL_HEIGHT / gTextures['background']:getHeight())

    self.playerDeck:render()
    AIHandGUI(self.rightAIDeck.hands, self.oppoAIDeck.hands, self.leftAIDeck.hands):render()

    self.menu:render()

    Timer.after(1, function()

        self.playerDecision = not self.playerDecision

        -- discard one tile
        x_pos = self.oppoAIBehaviour:determineTiletoDiscard()
        self.oppoAIDeck:discardTile(x_pos, self.oppoDiscardedTiles)
        playDiscardTile(self.oppoDiscardedTiles)
        local discardedTile = self.oppoDiscardedTiles[#self.oppoDiscardedTiles]

        self.playerDeck:checkPongKang(discardedTile)

        -- Checks After Oppo AI Discard
        -- 1. If LeftAI can win
        -- 2. If Player can win
        -- 3. If RightAI can win
        -- 4. If LeftAI can pong
        -- 5. If Player can pong
        if self.playerDeck.canPong then
            gSounds['bell']:play()
            self.menu["PongUI"]["available"] = 1
            self.countdown = not self.countdown
            selectionBox(3, 3, {1, 1}, 1):render()
            if self.seconds == 0 then
                self.countdown = not self.countdown
                self.menu["PongUI"]["available"] = 0
                self.playerDeck.canPong = not self.playerDeck.canPong
                self.oppoAIBehaviour:goDrawState(self.tileColor, self.jokerstring, self.drawWall, {self.playerDeck, self.rightAIDeck, self.oppoAIDeck, self.leftAIDeck}, {self.playerDiscardedTiles, self.rightDiscardedTiles, self.oppoDiscardedTiles, self.leftDiscardedTiles}) 
            end
        -- 6. If RightAI can pong
        -- 7. If LeftAI can chi
        -- 8. OppoAi discards goes to LeftAIDrawState
        else
            
            self.oppoAIBehaviour:goDrawState(self.tileColor, self.jokerstring, self.drawWall, {self.playerDeck, self.rightAIDeck, self.oppoAIDeck, self.leftAIDeck}, {self.playerDiscardedTiles, self.rightDiscardedTiles, self.oppoDiscardedTiles, self.leftDiscardedTiles})

        end

    end)

    if self.countdown then
        Timer.every(1, function()
            self.seconds = self.seconds - 1
        end)
        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.printf(self.seconds, VIRTUAL_WIDTH * 0.5, VIRTUAL_HEIGHT * 0.5, VIRTUAL_WIDTH * 0.5, "left")
        print(self.seconds)
    end

    -- reset the color
    love.graphics.setColor(1, 1, 1, 1)

end