--[[
    Mahjong oppoAIDrawState

    1. This is the state where the rightplayerAI draws one tile.
    2. This state is after 
        a) DealerPickingState -> RightAI is dealer 
        b) Right Opponent PONG or GANG --> Draws Replacement Tile
        c) Player (left of rightplayerAI) discards a tile -> Draws Tile
]]

oppoAIDrawState = Class{__includes = BaseState}

function oppoAIDrawState:init(tileColor, jokerstring, drawWall, decks, discardedTiles)
    
    self.menu = playerGUI({0, 0, 0, 0, 0})

end

function oppoAIDrawState:enter(params)

    self.tileColor = params.tileColor
    self.jokerstring = params.jokerstring
    self.drawWall = params.drawWall

    self.playerDeck, self.rightAIDeck, self.oppoAIDeck, self.leftAIDeck = params.decks[1], params.decks[2], params.decks[3], params.decks[4]
    self.playerDiscardedTiles, self.rightDiscardedTiles, self.oppoDiscardedTiles, self.leftDiscardedTiles = params.discardedTiles[1], params.discardedTiles[2], params.discardedTiles[3], params.discardedTiles[4]

end

function oppoAIDrawState:update(dt)

    self.oppoAIDeck:update(dt)

    -- draw tile
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        --gSounds['']:play()

            -- offically transfer playerHand's bonus tiles into self.playerFlowerWall
    end 

end

function oppoAIDrawState:render()

    -- background
    love.graphics.draw(gTextures['background'], 0, 0, 0, 
        VIRTUAL_WIDTH / gTextures['background']:getWidth(),
        VIRTUAL_HEIGHT / gTextures['background']:getHeight())

    self.playerDeck:render()
    AIHandGUI(self.rightAIDeck.hands, self.oppoAIDeck.hands, self.leftAIDeck.hands):render()

    self.menu:render()

    Timer.after(1, function()

        self.oppoAIDeck:drawTile(self.drawWall)
    
        gStateMachine:change('oppoAIDiscard',
        {
            tileColor = self.tileColor,
            jokerstring = self.jokerstring,
            drawWall = self.drawWall,
            decks = {self.playerDeck, self.rightAIDeck, self.oppoAIDeck, self.leftAIDeck},
            discardedTiles = {self.playerDiscardedTiles, self.rightDiscardedTiles, self.oppoDiscardedTiles, self.leftDiscardedTiles}
        })

    end)

    -- reset the color
    love.graphics.setColor(1, 1, 1, 1)

end