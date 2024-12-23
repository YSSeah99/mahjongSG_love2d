--[[
    Mahjong PlayerDrawState

    1. This is the state where the player draws one tile.
    2. This state is after 
        a) DealerPickingState -> Player is dealer 
        b) Player PONG or GANG --> Draws Replacement Tile
        c) AI (left of player) discards a tile -> Draws Tile
]]

PlayerDrawState = Class{__includes = BaseState}

function PlayerDrawState:init(tileColor, jokerstring, drawWall, decks, discardedTiles)

    self.bg = bgGUI()

    self.selectionBox = selectionBox(1, 3, {13, 1}, 3)
    self.menu = playerGUI({0, 0, 0, 0, 0})

end

function PlayerDrawState:enter(params)

    self.tileColor = params.tileColor
    self.jokerstring = params.jokerstring
    self.drawWall = params.drawWall

    self.playerDeck, self.rightAIDeck, self.oppoAIDeck, self.leftAIDeck = params.decks[1], params.decks[2], params.decks[3], params.decks[4]
    self.playerDiscardedTiles, self.rightDiscardedTiles, self.oppoDiscardedTiles, self.leftDiscardedTiles = params.discardedTiles[1], params.discardedTiles[2], params.discardedTiles[3], params.discardedTiles[4]
    
    --draws tile until playerHand = 13
    if #self.playerDeck.hands < self.playerDeck.handsCount then
        gSounds['tile-draw']:play()
        self.drawWall[1].area = 1
        table.insert(self.playerDeck.hands, self.drawWall[1])
        table.remove(self.drawWall, 1)
    end

end

function PlayerDrawState:update(dt)

    self.bg:update(dt)

    self.playerDeck:update(dt)
    self.selectionBox:update(dt)
    
    -- draw tile
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        local x_pos, y_pos = self.selectionBox:returnCords()
        if x_pos == 1 and y_pos == 3 then

            self.playerDeck:drawTile(self.drawWall)

            gStateMachine:change('playerDiscard',
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

function PlayerDrawState:render()

    -- background
    self.bg:render()

    self.playerDeck:render()
    AIHandGUI(self.rightAIDeck.hands, self.oppoAIDeck.hands, self.leftAIDeck.hands):render()
    
    self.menu:render()
    self.selectionBox:render()

    Timer.after(1, function()
        self.menu["DrawUI"]["available"] = 1
        self.selected_y = 3
    end)

end