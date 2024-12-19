--[[
    Mahjong leftAIDiscardState

    1. This is the state where the rightAI decides which of the 14 tiles to discard, provided that his tiles do not meet the winning conditions.
    2. This state is after 
        a) Player (left of rightAI) discards a tile and end its turn -> rightAIDrawState
        b) Player (left of rightAI) discards a tile -> RightAI CHI
        c) AI/Player (any player) discards a tile -> RightAI PONG or GANG 
]]

leftAIDiscardState = Class{__includes = BaseState}

function leftAIDiscardState:init(tileColor, jokerstring, drawWall, decks, discardedTiles)
    
    self.menu = playerGUI({0, 0, 0, 0, 0})

end

function leftAIDiscardState:enter(params)

    gSounds['tile-discard']:play()

    self.tileColor = params.tileColor
    self.jokerstring = params.jokerstring
    self.drawWall = params.drawWall

    self.playerDeck, self.rightAIDeck, self.oppoAIDeck, self.leftAIDeck = params.decks[1], params.decks[2], params.decks[3], params.decks[4]
    self.playerDiscardedTiles, self.rightDiscardedTiles, self.oppoDiscardedTiles, self.leftDiscardedTiles = params.discardedTiles[1], params.discardedTiles[2], params.discardedTiles[3], params.discardedTiles[4]

    -- draws tile until playerHand = 14
    
    Timer.after(1, function()

        x_pos = math.random(1, 14)
        self.leftAIDeck:discardTile(x_pos, self.leftDiscardedTiles)
        gStateMachine:change('playerDraw',
        {
            tileColor = self.tileColor,
            jokerstring = self.jokerstring,
            drawWall = self.drawWall,
            decks = {self.playerDeck, self.rightAIDeck, self.oppoAIDeck, self.leftAIDeck},
            discardedTiles = {self.playerDiscardedTiles, self.rightDiscardedTiles, self.oppoDiscardedTiles, self.leftDiscardedTiles}
        })


    end)

end

function leftAIDiscardState:update(dt)

    self.leftAIDeck:update(dt)
    -- draw tile
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
    end 

end

function leftAIDiscardState:render()

    -- need to check for winning condition!!!

    -- background
    love.graphics.draw(gTextures['background'], 0, 0, 0, 
        VIRTUAL_WIDTH / gTextures['background']:getWidth(),
        VIRTUAL_HEIGHT / gTextures['background']:getHeight())

    self.playerDeck:render()
    AIHandGUI(self.rightAIDeck.hands, self.oppoAIDeck.hands, self.leftAIDeck.hands):render()

    self.menu:render()

    -- reset the color
    love.graphics.setColor(1, 1, 1, 1)

end