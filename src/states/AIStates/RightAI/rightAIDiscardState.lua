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
    

end

function rightAIDiscardState:enter(params)

    gSounds['tile-discard']:play()

    self.tileColor = params.tileColor
    self.jokerstring = params.jokerstring
    self.drawWall = params.drawWall

    self.playerDeck, self.rightAIDeck, self.oppoAIDeck, self.leftAIDeck = params.decks[1], params.decks[2], params.decks[3], params.decks[4]
    self.playerDiscardedTiles, self.rightDiscardedTiles, self.oppoDiscardedTiles, self.leftDiscardedTiles = params.discardedTiles[1], params.discardedTiles[2], params.discardedTiles[3], params.discardedTiles[4]

    self.rightAIBehaviour = AIBehaviour('right', self.rightAIDeck, self.rightDiscardedTiles, params.decks, params.discardedTiles)

    self.countdown = Countdown(5, 'false')

end

function rightAIDiscardState:update(dt)

    self.rightAIDeck:update(dt)
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

    Timer.after(1, function()

        -- discard one tile
        x_pos = self.rightAIBehaviour:determineTiletoDiscard()
        self.rightAIDeck:discardTile(x_pos, self.rightDiscardedTiles)
        playDiscardTile(self.rightDiscardedTiles)
        local discardedTile = self.rightDiscardedTiles[#self.rightDiscardedTiles]

        self.playerchoiceGUI = playerchoiceGUI(discardedTile, self.playerDeck)

        self.playerDeck:checkPongKang(discardedTile)

        -- Checks After Right AI Discard
        -- 1. If OppoAI can win 
        -- 2. If LeftAI can win
        -- 3. If Player can win
        -- 4. If OppoAI can pong
        -- 5. If LeftAI can pong
        -- 6. If Player can pong
        if self.playerDeck.canPong then
            gSounds['bell']:play()
            Timer.after(gSounds['bell']:getDuration(), function() 
                self.menu["PongUI"]["available"] = 1
                selectionBox(3, 3, {1, 1}, 1):render()
                self.countdown.visible = true
            end)
            
            if self.countdown.seconds == 0 then
                self.countdown.visible = false
                self.menu["PongUI"]["available"] = 0
                self.playerDeck.canPong = not self.playerDeck.canPong
                self.rightAIBehaviour:goDrawState(self.tileColor, self.jokerstring, self.drawWall, {self.playerDeck, self.rightAIDeck, self.oppoAIDeck, self.leftAIDeck}, {self.playerDiscardedTiles, self.rightDiscardedTiles, self.oppoDiscardedTiles, self.leftDiscardedTiles}) 
            end
        -- 7. If OppoAI can chi
        -- 8. RightAi discards goes to OppoAIDrawState
        else
            
            self.rightAIBehaviour:goDrawState(self.tileColor, self.jokerstring, self.drawWall, {self.playerDeck, self.rightAIDeck, self.oppoAIDeck, self.leftAIDeck}, {self.playerDiscardedTiles, self.rightDiscardedTiles, self.oppoDiscardedTiles, self.leftDiscardedTiles})

        end

    

        --[[if self.playerDeck.canPong then
            
            love.graphics.setFont(gFonts['medium'])
            love.graphics.setColor(1, 1, 1, 1)
            local seconds = 3
                love.graphics.printf(tostring(seconds), VIRTUAL_WIDTH * 0.5, VIRTUAL_HEIGHT * 0.5, VIRTUAL_WIDTH * 0.5, "left")
            

        else]]--

            
        --end

    end)

    if self.countdown.visible then
        self.countdown:render()
    end

    -- reset the color
    love.graphics.setColor(1, 1, 1, 1)

end