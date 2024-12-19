--[[
    Mahjong PlayerDiscardState

    1. This is the state where the player decides which of the 14 tiles to discard, provided that his tiles do not meet the winning conditions.
    2. This state is after 
        a) leftAI (left of Player) discards a tile and end its turn -> rightAIDrawState
        b) leftAI (left of Player) discards a tile -> RightAI CHI
        c) AIs (any player) discards a tile -> Player PONG or GANG 
]]

PlayerDiscardState = Class{__includes = BaseState}

function PlayerDiscardState:init(tileColor, jokerstring, drawWall, decks, discardedTiles)
    
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

    self.playerDeck:update(dt)
    self.selectionBox:update(dt)

    -- draw tile
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        
        local x_pos, y_pos = self.selectionBox:returnCords()

        if y_pos == 2 then

            self.playerDeck:discardTile(x_pos, self.playerDiscardedTiles)
            gStateMachine:change('rightAIDraw',
            {
                tileColor = self.tileColor,
                jokerstring = self.jokerstring,
                drawWall = self.drawWall,
                decks = {self.playerDeck, self.rightAIDeck, self.oppoAIDeck, self.leftAIDeck},
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