--[[
    Mahjong rightAIDiscardState

    1. This is the state where the rightAI decides which of the 14 tiles to discard, provided that his tiles do not meet the winning conditions.
    2. This state is after 
        a) Player (left of rightAI) discards a tile and end its turn -> rightAIDrawState
        b) Player (left of rightAI) discards a tile -> RightAI CHI
        c) AI/Player (any player) discards a tile -> RightAI PONG or GANG 
]]

rightAIDiscardState = Class{__includes = BaseState}

function rightAIDiscardState:init(tileColor, jokerstring, drawWall, decks, discardedTiles)
    
    self.menu = playerGUI({0, 0, 0, 0, 0})
    self.discardedTile = nil

    self.selectionBoxforPlayerChi = selectionBox(2, 3, {1, 1}, 1)
    self.selectionBoxforPlayerPong = selectionBox(3, 3, {1, 1}, 1)
    self.selectionBoxforPlayerKang = selectionBox(4, 3, {1, 1}, 1)
    self.selectionBoxforPlayerWin = selectionBox(5, 3, {1, 1}, 1)
    
end

function rightAIDiscardState:enter(params)

    gSounds['tile-discard']:play()

    self.tileColor = params.tileColor
    self.jokerstring = params.jokerstring
    self.drawWall = params.drawWall

    self.playerDeck, self.rightAIDeck, self.oppoAIDeck, self.leftAIDeck = params.decks[1], params.decks[2], params.decks[3], params.decks[4]
    self.playerDiscardedTiles, self.rightDiscardedTiles, self.oppoDiscardedTiles, self.leftDiscardedTiles = params.discardedTiles[1], params.discardedTiles[2], params.discardedTiles[3], params.discardedTiles[4]

    self.rightAIBehaviour = AIBehaviour('right', self.rightAIDeck, self.rightDiscardedTiles, params.decks, params.discardedTiles)

    self.countdown = Countdown(6)

end

function rightAIDiscardState:update(dt)

    self.rightAIBehaviour:update(dt)
    self.countdown:update(dt)

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

    self.playerDeck:render()
    AIHandGUI(self.rightAIDeck.hands, self.oppoAIDeck.hands, self.leftAIDeck.hands):render()

    self.menu:render()

    -- renders countdown timer and selectionmenu
    if self.countdown.visible == true then

        if self.playerDeck.canPong then 
            self.selectionBoxforPlayerPong:render() 
            self.countdown:render("Pong?", self.discardedTile)
        elseif self.playerDeck.canKang then 
            self.selectionBoxforPlayerKang:render() 
            self.countdown:render("Kang?", self.discardedTile) 
        end

    end

    Timer.after(1, function()

        -- discard one tile
        x_pos = self.rightAIBehaviour:determineTiletoDiscard()
        self.rightAIDeck:discardTile(x_pos, self.rightDiscardedTiles)
        playDiscardTile(self.rightDiscardedTiles)
        self.discardedTile = self.rightDiscardedTiles[#self.rightDiscardedTiles]

        self.playerDeck:checkPongKang(self.discardedTile)

        -- Checks After Right AI Discard
        -- 1. If OppoAI can win 
        -- 2. If LeftAI can win
        -- 3. If Player can win
        -- 4. If OppoAI can pong / kang
        -- 5. If LeftAI can pong / kang
        -- 6. If Player can pong / kang
        if self.playerDeck.canPong then

            gSounds['bell']:play()
            Timer.after(gSounds['bell']:getDuration(), function() gSounds['bell']:stop() end)
            self.menu["PongUI"]["available"] = 1
            self.countdown.visible = true

            if self.countdown.seconds == 0 then
                self.countdown.visible = false
                self.menu["PongUI"]["available"] = 0
                self.playerDeck.canPong = not self.playerDeck.canPong
                self.rightAIBehaviour:goDrawState(self.tileColor, self.jokerstring, self.drawWall, {self.playerDeck, self.rightAIDeck, self.oppoAIDeck, self.leftAIDeck}, {self.playerDiscardedTiles, self.rightDiscardedTiles, self.oppoDiscardedTiles, self.leftDiscardedTiles}) 
            end

        elseif self.playerDeck.canKang then

            gSounds['bell']:play()
            Timer.after(gSounds['bell']:getDuration(), function() gSounds['bell']:stop() end)
            self.menu["KangUI"]["available"] = 1
            self.countdown.visible = true

            if self.countdown.seconds == 0 then
                self.countdown.visible = false
                self.menu["KangUI"]["available"] = 0
                self.playerDeck.canKang = not self.playerDeck.canKang
                self.rightAIBehaviour:goDrawState(self.tileColor, self.jokerstring, self.drawWall, {self.playerDeck, self.rightAIDeck, self.oppoAIDeck, self.leftAIDeck}, {self.playerDiscardedTiles, self.rightDiscardedTiles, self.oppoDiscardedTiles, self.leftDiscardedTiles}) 
            end
        -- 7. If OppoAI can chi
        -- 8. RightAi discards goes to OppoAIDrawState
        else
            
            self.rightAIBehaviour:goDrawState(self.tileColor, self.jokerstring, self.drawWall, {self.playerDeck, self.rightAIDeck, self.oppoAIDeck, self.leftAIDeck}, {self.playerDiscardedTiles, self.rightDiscardedTiles, self.oppoDiscardedTiles, self.leftDiscardedTiles})

        end

    end)

    -- reset the color
    love.graphics.setColor(1, 1, 1, 1)

end